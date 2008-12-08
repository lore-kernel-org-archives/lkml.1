Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYLHGsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYLHGsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYLHGsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:48:03 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:16196 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYLHGsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u2zSlhbtkwuo6BpRKR1o4XYetLXY5rfSCeCQ8oFIi/DjpmS0K6O1IrdfDmKKiKomyq
         7p9UJzaNiOmLGO3Tf4JDus48Zw7eruGc0CfxHyY1Z8hpxvKDwjZjGZQU9ZfeLbOhcsc+
         1w05erRA1/5Rt/bctISYLrUbmlzVyJVk+kyRA=
Message-ID: <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
Date: Mon, 8 Dec 2008 07:48:00 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20081207141337.588aede5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493AE770.5030507@shaw.ca>
	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>
	 <493AF2EA.4030601@shaw.ca>
	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
	 <493B4242.1040202@shaw.ca>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed something else, which though may be due to my inexperience
with mce messages. In my directory /sys/devices/system/machinecheck
there are machinecheck0-7(one for each logical cpu of my system I
presume). Having received the MCE log always for cpu 0, I went to look
inside dir machinecheck0 and I found bank0-5ctl. So now my question
is, why do I receive MCE logs about bank 6, if my cpus don't have a
bank 6? Does that count start from 1? Or am I missing something else?

Log of MCEs(They all happended once for each reboot):

"Boot 0"
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 6 MISC 202d ADDR ffeef740
MCG status:
MCi status:
Error overflow
Uncorrected error
MCi_MISC register valid
MCi_ADDR register valid
Processor context corrupt
MCA: Generic CACHE Level-2 Data-Write Error
STATUS ee0000000100014a MCGSTATUS 0

"Boot 1"
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 6 MISC 308 ADDR ffefac00
MCG status:
MCi status:
Error overflow
Uncorrected error
MCi_MISC register valid
MCi_ADDR register valid
Processor context corrupt
MCA: Generic CACHE Level-2 Read Error
STATUS ee0000000100011a MCGSTATUS 0

"Boot 2"
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 6 MISC 212d ADDR ffef77c0
MCG status:
MCi status:
Error overflow
Uncorrected error
MCi_MISC register valid
MCi_ADDR register valid
Processor context corrupt
MCA: Generic CACHE Level-2 Data-Write Error
STATUS ee0000000100014a MCGSTATUS 0

"Boot 3"
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 6 MISC 202d ADDR ffee0280
MCG status:
MCi status:
Error overflow
Uncorrected error
MCi_MISC register valid
MCi_ADDR register valid
Processor context corrupt
MCA: Generic CACHE Level-2 Data-Write Error
STATUS ee0000000100014a MCGSTATUS 0

"Boot 4"
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 6 MISC 202d ADDR ffef5cc0
MCG status:
MCi status:
Error overflow
Uncorrected error
MCi_MISC register valid
MCi_ADDR register valid
Processor context corrupt
MCA: Generic CACHE Level-2 Data-Write Error
STATUS ee0000000100014a MCGSTATUS 0

"Boot 5"
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 6 MISC 212d ADDR ffef2f40
MCG status:
MCi status:
Error overflow
Uncorrected error
MCi_MISC register valid
MCi_ADDR register valid
Processor context corrupt
MCA: Generic CACHE Level-2 Data-Write Error
STATUS ee0000000100014a MCGSTATUS 0

Thanks for the help,

Giangiacomo
