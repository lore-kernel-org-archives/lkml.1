Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXBEKgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXBEKgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXBEKgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:36:35 -0500
Received: from jdi.jdi-ict.nl ([82.94.239.5]:39142 "EHLO jdi.jdi-ict.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbXBEKge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:36:34 -0500
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 05:36:34 EST
Date: Mon, 5 Feb 2007 11:24:30 +0100 (CET)
From: Igmar Palsenberg <i.palsenberg@jdi-ict.nl>
X-X-Sender: igmar@jdi.jdi-ict.nl
To: Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, npiggin@suse.de, erich <erich@areca.com.tw>
Subject: Re: 2.6.16.32 stuck in generic_file_aio_write()
In-Reply-To: <20061214011042.7b279be6.akpm@osdl.org>
Message-ID: <Pine.LNX.4.58.0702051118230.30521@jdi.jdi-ict.nl>
References: <Pine.LNX.4.58.0611291329060.18799@jdi.jdi-ict.nl>
 <20061130212248.1b49bd32.akpm@osdl.org> <Pine.LNX.4.58.0612010926030.31655@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612042201001.14643@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612061615550.24526@jdi.jdi-ict.nl> <20061206074008.2f308b2b.akpm@osdl.org>
 <Pine.LNX.4.58.0612070940590.28683@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612071328030.9115@jdi.jdi-ict.nl>
 <Pine.LNX.4.58.0612140912010.30202@jdi.jdi-ict.nl> <20061214004213.13149a48.akpm@osdl.org>
 <Pine.LNX.4.58.0612140953080.9623@jdi.jdi-ict.nl> <20061214011042.7b279be6.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (jdi.jdi-ict.nl [127.0.0.1]); Mon, 05 Feb 2007 11:24:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Does the other machine have the same problems?

It does. It seems to depend on the interrupt frequency : Setting KERNEL_HZ=250
makes it ony appear once a month or so, with KERNEL_HZ=1000, it will 
occur within a week. It does happen a lot less with the other machine, 
which isn't under disk activity load as much as the other machine.
 
> Are you able to rule out a hardware failure?

Well.. It's too much coincidence that 2 (almost identical) machines show 
the same weard behaviour. What strikes me that only *disk* interrupts 
after a while don't get handled. The machine itself is alive, just all 
disk IO is blocked, which makes it pretty much useless. 

Erich, could this be some sort of hardware problem ? I know it's a PITA to 
reproduce, but setting CONFIG_HZ to 1000 and bashing the machine with 
diskactivity seems to help :)


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
