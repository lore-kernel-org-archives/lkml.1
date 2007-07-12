Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbXGLXkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbXGLXkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759382AbXGLXj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:39:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:1336 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbXGLXj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:39:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GS7cliIH/kd/BL60GrVGpOVp/Z1iidHaGeRD24HaJ5vxzfM3cRkdNe+XjzmoyKQedzfjAvUWvtcc1OzkZbEperSpQFcDJHjZRiod1ENT3xfogvRyfDv8SlHlCSr4FnL1mjO9408I6Lo5xGonjah2Kpf+yVJftYWI4NZpVMf6sQw=
Message-ID: <6bffcb0e0707121639y43020few7fffe3077c4544d7@mail.gmail.com>
Date: Fri, 13 Jul 2007 01:39:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [GIT] SELinux changes for 2.6.23 (updated)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Stephen Smalley" <sds@tycho.nsa.gov>
In-Reply-To: <Line.LNX.4.64.0707112315480.30564@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Line.LNX.4.64.0707112315480.30564@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/07/07, James Morris <jmorris@namei.org> wrote:
> This is an updated set of 2.6.23 SELinux changes, rebased & tested against
> current git.  The vmsplice patch has been dropped from this and will be
> resubmitted via Jens.  Also added an ack from Chris Wright for the mmap
> null dereference hooks (which I'd forgotten to add to my tree some time
> ago).
>
> Please pull.
>
>

My system is too secure, I can not login :)

[   48.388454] audit(1184282973.821:4): avc:  denied  { recvfrom } for
 pid=1168 comm="rhgb" saddr=127.0.0.1 src=40501 daddr=127.0.0.1
dest=6009 netif=lo scontext=system_u:system_r:xdm_xserver_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=tcp_socket
[   48.572508] PM: Adding info for No Bus:vcs8
[   48.576842] PM: Adding info for No Bus:vcsa8
[   51.403651] audit(1184282976.821:5): avc:  denied  { recvfrom } for
 saddr=127.0.0.1 src=40501 daddr=127.0.0.1 dest=6009 netif=lo
scontext=system_u:system_r:xdm_xserver_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=tcp_socket
[   57.389935] audit(1184282982.820:6): avc:  denied  { recvfrom } for
 saddr=127.0.0.1 src=40501 daddr=127.0.0.1 dest=6009 netif=lo
scontext=system_u:system_r:xdm_xserver_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=tcp_socket
[   69.362541] audit(1184282994.818:7): avc:  denied  { recvfrom } for
 saddr=127.0.0.1 src=40501 daddr=127.0.0.1 dest=6009 netif=lo
scontext=system_u:system_r:xdm_xserver_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=tcp_socket
[   93.307790] audit(1184283018.814:8): avc:  denied  { recvfrom } for
 saddr=127.0.0.1 src=40501 daddr=127.0.0.1 dest=6009 netif=lo
scontext=system_u:system_r:xdm_xserver_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=tcp_socket

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-g4eb6bf6b/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-g4eb6bf6b/git-config2

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
