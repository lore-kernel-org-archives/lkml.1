Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXDBOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXDBOT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965489AbXDBOTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:19:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44894 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965472AbXDBOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:19:55 -0400
Date: Mon, 2 Apr 2007 19:57:27 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com,
       dev@sw.ru, xemul@sw.ru, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070402142727.GF2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402140938.GF17710@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 09:09:39AM -0500, Serge E. Hallyn wrote:
> Losing the directory isn't a big deal though.  And both unsharing a
> namespace (which causes a ns_container_clone) and mounting the hierarchy
> are done by userspace, so if for some installation it is a big deal,
> the init scripts on initrd can mount the hierarchy before doing any
> unsharing.

Yes I thought of that after posting this (that initrd can mount the
hierarchies), so this should not be an issue in practice ..

> Can you think of a reason why losing a few directories matters?

If we loose directories, then we don't have a way to manage the
task-group it represents thr' the filesystem interface, so I consider
that bad. As we agree, this will not be an issue if initrd
mounts the ns hierarchy atleast at bootup.

-- 
Regards,
vatsa
