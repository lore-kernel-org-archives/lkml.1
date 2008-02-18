Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbYBRX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbYBRX2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762904AbYBRX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:27:04 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56454 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762553AbYBRX1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:27:02 -0500
Date: Tue, 19 Feb 2008 00:27:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Frans Pop <elendil@planet.nl>
cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
In-Reply-To: <200802181131.04498.elendil@planet.nl>
Message-ID: <Pine.LNX.4.64.0802190000590.26274@fbirervta.pbzchgretzou.qr>
References: <47b8c177.2QDr0ADTa5ExM+/T%Joerg.Schilling@fokus.fraunhofer.de>
 <E1JR1e0-0001R1-IR@faramir.fjphome.nl> <1203324960.24098.3.camel@homer.simson.net>
 <200802181131.04498.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 18 2008 11:31, Frans Pop wrote:
>> >
>> > There is also the 100% certainty that this reply was from a known troll
>> > and should just be ignored.
>>
>> That was rude, crude and uncalled for.
>
>I have no problems with my reply being called "rude" or "crude". After all, 
>I wasn't even remotely trying to be nice or considerate.
>
>However, I do think it was called for as mr. Schilling's reply was nothing 
>other than the next mail in his endlessly running FUD campain against 
>Wodim. If you're not aware of that campain, please try for example the 
>following link:

They both compaign against each other, but whatever they do

I choose cdrtools because it has the little extra:

http://pastebin.ca/909154 - cdrecord output of two commands
http://pastebin.ca/909160 - wodim output of two commands

Or in short, readable form:

Reading ATIP from a DVD:
--- wodim       2008-02-19 00:10:32.492871654 +0100
+++ cdrtools    2008-02-19 00:05:36.322901247 +0100
@@ 0,0 0,0 @@
-Supported modes: PACKET SAO
-  ATIP start of lead in:  -150 (00:00/00)
-Disk type:    unknown dye (reserved id code)
-Manuf. index: -1
-Manufacturer: unknown (not in table)

+Supported modes: PACKET SAO LAYER_JUMP
+book type:       DVD-ROM, Version (0.1)
+disc size:       120mm (0)
+maximum rate:    10.08 MB/s (2)
+number of layers:2
+track path:      Opposite Track Path (1)
[...]


Drive capabilities:

-Device seems to be: Generic mmc2 DVD-R/DVD-RW.
-Current: 0x0010
-Profile: 0x0012 
-Profile: 0x0010 (current)
[...]
+Device seems to be: Generic mmc2 DVD-R/DVD-RW/DVD-RAM.
+Current: DVD-ROM
+Profile: DVD-RAM 
+Profile: DVD-ROM (current)
[...]
