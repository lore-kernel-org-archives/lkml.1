Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbYJSDRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbYJSDRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 23:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYJSDRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 23:17:13 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:51893 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYJSDRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 23:17:12 -0400
Date: Sun, 19 Oct 2008 01:16:58 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Scott Wood <scottwood@freescale.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org, rbrito@ime.usp.br
Subject: Re: [PATCH] powerpc: enable heap randomization for linkstations
Message-ID: <20081019031658.GC7887@ime.usp.br>
References: <20081013040703.GA11059@ime.usp.br> <20081013045116.GA11637@ime.usp.br> <Pine.LNX.4.64.0810132003350.9041@axis700.grange> <20081013184443.GA20612@ld0162-tx32.am.freescale.net> <20081019025323.GA7887@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081019025323.GA7887@ime.usp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On Oct 18 2008, Rogério Brito wrote:
> And it seems that there is something not quite right for these embedded
> systems. Here is something that I get with a vanilla linkstation_defconfig:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(...)
> I just saw that in the default config:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> # CONFIG_PPC_CLOCK is not set
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> Maybe this should be enabled? I can iterate once more to see if this
> option would make any difference here.

Even if I enable this option, I still get the same problem as above. :-(


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
