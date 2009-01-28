Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZA1VrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZA1VrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZA1VqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:46:11 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:39939 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZA1VqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:46:10 -0500
Date: Wed, 28 Jan 2009 15:46:08 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128214608.GA1495059@hiwaay.net>
References: <bF63r-1nB-59@gated-at.bofh.it> <bXmsS-4eW-1@gated-at.bofh.it> <bXmMj-4HC-7@gated-at.bofh.it> <bXqQ1-2GV-49@gated-at.bofh.it> <bXxHH-5zl-23@gated-at.bofh.it> <bXQqZ-1hm-9@gated-at.bofh.it> <bYb2q-8bp-21@gated-at.bofh.it> <bYchR-1AT-3@gated-at.bofh.it> <bZ6Di-6ZV-1@gated-at.bofh.it> <bZ9rz-2X3-7@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Davide Libenzi  <davidel@xmailserver.org> said:
>I already gave you my opinion on such code. There is no need for it. If 
>your servers are loaded, in the same way you bump NFILES (and likely 
>even other default configs), you bump up max_user_instances:

The flip side of that is this could just be added to the list of limits
you set on a multi-user system if you don't want $LUSER to DoS your
server (such as max procs, cpu time, virtual memory, etc.).  I don't
think this is a security issue on single-user systems or servers with
only privileged access.

Admins of multi-user systems are used to having to manage limits (see
pam_limits for example).  Admins of single-user or privileged servers
(e.g. mail or non-shared web servers) are not for the most part (postfix
doesn't open 1025 files in a single process).

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
