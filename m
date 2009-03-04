Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZCDBFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZCDBFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZCDBFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:05:06 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:38697 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZCDBFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:05:05 -0500
Date: Tue, 3 Mar 2009 22:04:53 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Tony Breeds <tony@bakeyournoodle.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Anton Blanchard <anton@samba.org>
Subject: Re: Linux 2.6.29-rc6 bombs while compiling a kernel for a
	linkstation/kurobox
Message-ID: <20090304010453.GA18621@ime.usp.br>
References: <20090302094303.GA29819@ime.usp.br> <Pine.LNX.4.64.0903040103440.5059@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0903040103440.5059@axis700.grange>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 04 2009, Guennadi Liakhovetski wrote:
> Yes, linkstation and storcenter have to migrate to the "physmap-flash" 
> platform driver. For now you can define in your .config
> 
> CONFIG_MTD_PHYSMAP=y
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0xffc00000
> CONFIG_MTD_PHYSMAP_LEN=0x400000
> CONFIG_MTD_PHYSMAP_BANKWIDTH=1

I did that already yesterday. Please, see my patch at
http://marc.info/?l=linux-kernel&m=123606933628020&w=4

And the entry at bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=12811

> (I hope the numbers are correct, just found them in my local tree, don't 
> remember any more what exactly they configure, please, double-check.)

Yes, I had them in my tree also. And it is tested already, up and
running and in production for 17 hours.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rbrito@lutz:~$ uptime
 22:03:16 up 17:06,  1 user,  load average: 0.16, 0.03, 0.01
rbrito@lutz:~$ 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

> And yes, it must be fixed in the mainline. I'll see if I find time for
> this, maybe tomorrow (actually, already today.)

Please, Cc me any relevant patches, as I'm not subscribed to all those
lists.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
