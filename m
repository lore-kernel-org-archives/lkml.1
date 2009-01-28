Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbZA2Ab2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbZA2Ab2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbZA1Xyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:54:52 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42243 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760255AbZA1Xyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:54:50 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Jan 2009 15:54:49 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Chris Adams <cmadams@hiwaay.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <20090128214608.GA1495059@hiwaay.net>
Message-ID: <alpine.DEB.1.10.0901281551490.21401@alien.or.mcafeemobile.com>
References: <bF63r-1nB-59@gated-at.bofh.it> <bXmsS-4eW-1@gated-at.bofh.it> <bXmMj-4HC-7@gated-at.bofh.it> <bXqQ1-2GV-49@gated-at.bofh.it> <bXxHH-5zl-23@gated-at.bofh.it> <bXQqZ-1hm-9@gated-at.bofh.it> <bYb2q-8bp-21@gated-at.bofh.it> <bYchR-1AT-3@gated-at.bofh.it>
 <bZ6Di-6ZV-1@gated-at.bofh.it> <bZ9rz-2X3-7@gated-at.bofh.it> <20090128214608.GA1495059@hiwaay.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Chris Adams wrote:

> Once upon a time, Davide Libenzi  <davidel@xmailserver.org> said:
> >I already gave you my opinion on such code. There is no need for it. If 
> >your servers are loaded, in the same way you bump NFILES (and likely 
> >even other default configs), you bump up max_user_instances:
> 
> The flip side of that is this could just be added to the list of limits
> you set on a multi-user system if you don't want $LUSER to DoS your
> server (such as max procs, cpu time, virtual memory, etc.).  I don't
> think this is a security issue on single-user systems or servers with
> only privileged access.
> 
> Admins of multi-user systems are used to having to manage limits (see
> pam_limits for example).  Admins of single-user or privileged servers
> (e.g. mail or non-shared web servers) are not for the most part (postfix
> doesn't open 1025 files in a single process).

It seems this is the most agreeable solution based on this thread replies. 
That is, leave it unbound, and offer limiting capabilities to multiuser 
sysadmins.



- Davide


