Return-Path: <linux-kernel-owner+w=401wt.eu-S1161751AbXBPE3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161751AbXBPE3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423148AbXBPE3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:29:07 -0500
Received: from ind-iport-1.cisco.com ([64.104.129.195]:14204 "EHLO
	ind-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161754AbXBPE3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:29:05 -0500
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 23:29:04 EST
X-IronPort-AV: i="4.14,179,1170613800"; 
   d="scan'208"; a="75583781:sNHT66554564"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: kernel porting query
Date: Fri, 16 Feb 2007 09:48:45 +0530
Message-ID: <677342AB6AE12D4DB59A9D473F40D74B028E0411@xmb-blr-416.apac.cisco.com>
In-Reply-To: <7783925d0702151816r7df63816ld9c69b56bdb0a0b9@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel porting query
Thread-Index: AcdRcNkpR+qYBEpSTM2TXIT2QuvmOQADqvFQ
References: <7783925d0702151816r7df63816ld9c69b56bdb0a0b9@mail.gmail.com>
From: "Ajay Singh \(ajaysi\)" <ajaysi@cisco.com>
To: "Rick Brown" <rick.brown.3@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "kernelnewbies" <kernelnewbies@nl.linux.org>,
       <linux-newbie@vger.kernel.org>
X-OriginalArrivalTime: 16 Feb 2007 04:18:45.0434 (UTC) FILETIME=[8C91B9A0:01C75181]
Authentication-Results: ind-dkim-1; header.From=ajaysi@cisco.com; dkim=pass (
	sig from cisco.com/inddkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

<snip> 
1) Can any one please shed some light on precisely and exactly what are
differences in different boards for which we need to port linux?

The differences depends on the boards ... Mostly if they belong to the
same family the differences could be mainly in the peripherials ...
Interrupt mappings... Serial interface ... Memory sizes (if differnet
boards have different memory sizes) ... Sometimes some devices may be
moved to some other locations in the memory map (Look at memory map of
your SoC on your board). 

2) Also, I would appreciate if you could point out code portions /
source files that need to be changed in the process of porting Linux?

Look in linux-2.6.20\arch\mips\mips-boards for help on porting to your
board. You can add directory specific to your board here.
I think you can start from xxx_setup.c file in the above directory.

Good luck.
Ajay.

TIA,

Rick

--
To unsubscribe from this list: send an email with "unsubscribe
kernelnewbies" to ecartis@nl.linux.org Please read the FAQ at
http://kernelnewbies.org/FAQ
