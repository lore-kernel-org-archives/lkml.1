Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbZC0Asw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbZC0Asw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933554AbZC0AsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:48:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:1714 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556AbZC0AsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:48:20 -0400
Date: Fri, 27 Mar 2009 11:46:42 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: TOMOYO in linux-next
In-Reply-To: <20090327003620.GI29836@elf.ucw.cz>
Message-ID: <alpine.LRH.2.00.0903271145380.11179@tundra.namei.org>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <20090327003620.GI29836@elf.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Pavel Machek wrote:

> Hi!
> 
> > As for the rest of the feedback, please work with the developers to fix 
> > any bugs or lack of documentation.
> 
> Apparently not even its user<->kernel interface was reviewed. This
> violates "one value per file in sysfs":
> 
>     [root@tomoyo]# cat /sys/kernel/security/tomoyo/meminfo
>     Shared:       61440
>     Private:      69632
>     Dynamic:        768
>     Total:       131840
>     
>     You can set memory quota by writing to this file.
>     (Example)
>     [root@tomoyo]# echo Shared: 2097152 > /sys/kernel/security/tomoyo/meminfo
>     [root@tomoyo]# echo Private: 2097152 > /sys/kernel/security/tomoyo/meminfo

This is not sysfs, it's securityfs, with their documentation showing it 
mounted on /sys.


- James
-- 
James Morris
<jmorris@namei.org>
