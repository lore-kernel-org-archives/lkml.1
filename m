Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZDXG7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZDXG7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZDXG7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:59:11 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:59478 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZDXG7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:59:10 -0400
Date: Fri, 24 Apr 2009 03:58:16 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Regarding the linkstation defconfig
Message-ID: <20090424065816.GA15525@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guennadi, Kumar & Co.

Guennadi, since you seem to be the one responsible for the
linkstation/kurobox in the kernel, I would like to ask you a few things
that I couldn't quite understand. Please, forgive my ignorance here
while I ask you some things:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 01. why is anticipatory the default scheduler for linkstations when CFQ
     is the default scheduler for the rest of the kernel?

 02. since kuroboxes/linkstations are meant to store files, is there any
     reason why they don't have support for large blk devs enabled by
     default?

 03. why is CONFIG_MIGRATION enabled in such low memory devices?

 04. why is CONFIG_BLK_DEV_RAM enabled by default?

 05. why is SCSI_LOWLEVEL enabled, if no device under that tree is used?

 06. idem for CONFIG_NETDEV_10000.

 07. idem for CONFIG_WIRELESS.

 08. idem for CONFIG_HWMON.

 09. idem for CONFIG_CRYPTO_HW.

 10. any reason why CONFIG_VIDEO_OUTPUT_CONTROL is configured as a
     module?

 11. any reason why CIFS is not configured with extended attributes,
     while both ext3 and nfs are?

 12. wouldn't it be a good thing to enable CONFIG_PRINTK_TIME?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Perhaps similar remarks would apply to the other device that you
maintain? I forgot its name.

Again, please, forgive my ignorance here regarding the questions above.
I'm really looking for some clarification and to get things in shape
both on my systems and in the default kernel configuration, in general.


Thank you very much for your contributions, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
