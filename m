Return-Path: <linux-kernel-owner+w=401wt.eu-S964817AbXBLJ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbXBLJ14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964818AbXBLJ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:27:56 -0500
Received: from jdi.jdi-ict.nl ([82.94.239.5]:45654 "EHLO jdi.jdi-ict.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817AbXBLJ1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:27:55 -0500
Date: Mon, 12 Feb 2007 10:26:44 +0100 (CET)
From: Igmar Palsenberg <i.palsenberg@jdi-ict.nl>
X-X-Sender: igmar@jdi.jdi-ict.nl
To: erich <erich@areca.com.tw>
cc: Andrew Morton <akpm@osdl.org>, linux kernel <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Subject: Re: 2.6.16.32 stuck in generic_file_aio_write()
In-Reply-To: <000501c74998$79b41490$4e00a8c0@erich2003>
Message-ID: <Pine.LNX.4.58.0702120954360.30957@jdi.jdi-ict.nl>
References: <Pine.LNX.4.58.0611291329060.18799@jdi.jdi-ict.nl>
 <20061130212248.1b49bd32.akpm@osdl.org> <Pine.LNX.4.58.0612010926030.31655@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612042201001.14643@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612061615550.24526@jdi.jdi-ict.nl> <20061206074008.2f308b2b.akpm@osdl.org>
 <Pine.LNX.4.58.0612070940590.28683@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612071328030.9115@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612140912010.30202@jdi.jdi-ict.nl> <20061214004213.13149a48.akpm@osdl.org>
 <Pine.LNX.4.58.0612140953080.9623@jdi.jdi-ict.nl> <20061214011042.7b279be6.akpm@osdl.org>
 <Pine.LNX.4.58.0702051118230.30521@jdi.jdi-ict.nl> <000501c74998$79b41490$4e00a8c0@erich2003>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (jdi.jdi-ict.nl [127.0.0.1]); Mon, 12 Feb 2007 10:26:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> I can not make sure it is hardware problem, but I have interest in this 
> case's reproducing.
> If you tell me your platform's construction, I will try it and give you good 
> solution.

The machines giving problems are almost identical when it comes to 
hardware specs :

Intel SE7520BD2 mainbord (SE7520 chipset)
Dual Intel Xeon 2.8 Ghz (other machine : Dual Xeon 3.2 Ghz)
4 GB PC3200 ECC (400 Mhz) Corsair (other machine : 2GB PC3200 ECC)

> Does your RAID adapter's firmware version work on 1.42?
> Areca firmware had fix some hardware bugs and rare sg length handle in this 
> version.

It's currently at 1.41. I'll see if I can upgrade it to 1.42. For now, 
I've put all available stacktraces when it hung on 
http://www.jdi-ict.nl/areca, together with a lspci -v -v and a copy of the 
kernel's .config

Please let me know if you need anything else.



Regards,


	Igmar




-- 
Igmar Palsenberg
JDI ICT

Zutphensestraatweg 85
6953 CJ Dieren
Tel: +31 (0)313 - 496741
Fax: +31 (0)313 - 420996
The Netherlands

mailto: i.palsenberg@jdi-ict.nl
