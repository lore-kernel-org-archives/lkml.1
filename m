Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXGIUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXGIUMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbXGIUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:12:03 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:6946 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbXGIUMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:12:01 -0400
Message-ID: <46929691.8050103@fr.ibm.com>
Date: Mon, 09 Jul 2007 22:12:01 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org> <20070709120236.GC4509@MAIL.13thfloor.at> <46923521.4040109@openvz.org> <20070709195240.GA27189@MAIL.13thfloor.at>
In-Reply-To: <20070709195240.GA27189@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> 3. Suka assumes that pid namespace can live without proc mount
>>>>    and tries to make the code work with pid_ns->proc_mnt change
>>>>    from NULL to not-NULL from times to times.
>>>>    My code calls the kern_mount() at the namespace creation and
>>>>    thus the pid_namespace always works with proc.
>>> shouldn't that be done by userspace instead?
>> It can be. But when the namespace is being created there's no
>> any userspace in it yet.
> 
> I'm not talking about the 'userspace inside the space'
> I'm talking about the userspace creating the space
> (what if I do not want to have any proc mount?)

yes, can't we let the user doing the unshare or clone decide whether
it needs to mount /proc or not in the new pid namespace ?

that's already optional on the host. 

C.
