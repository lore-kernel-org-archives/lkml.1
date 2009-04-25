Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZDYFOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZDYFOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 01:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZDYFNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 01:13:51 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:59118 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZDYFNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 01:13:51 -0400
Date: Sat, 25 Apr 2009 02:12:18 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc3][Regression] Compilation failure [SOLVED-PARTIALLY]
Message-ID: <20090425051218.GA767@ime.usp.br>
References: <20090424091412.GA15074@ime.usp.br> <alpine.LFD.2.00.0904241445430.10096@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0904241445430.10096@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, Len.

On Apr 24 2009, Len Brown wrote:
> > (.text+0x87d2e): undefined reference to `acpi_video_register'
> 
> try this:
> http://patchwork.kernel.org/patch/19821/

Even though I have no modesetting compiled in the kernel, I *did* have
the options VIDEO_OUTPUT_CONTROL, BACKLIGHT_CLASS_DEVICE, INPUT,
ACPI_VIDEO enabled, but two of them (BACKLIGHT_CLASS_DEVICE and
ACPI_VIDEO) selected as modules.

Selecting them as "y" fixed the compilation problem.

I guess that you just wanted to know this.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
