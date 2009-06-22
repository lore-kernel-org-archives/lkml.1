Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZFVTtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZFVTtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZFVTtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:49:11 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61203 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZFVTtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:49:10 -0400
Message-ID: <4A3FE035.2010804@nodomain.org>
Date: Mon, 22 Jun 2009 20:49:09 +0100
From: Tony Hoyle <tmh@nodomain.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: snd_hda_intel on linux 2.6.30
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been trying to get sound working on a Poulsbo board using 2.6.30. 
Previously, with the available patches sound worked OK.

2.6.30 has most of the patches already in, and the the Intel HDA is 
indeed recognized, but no sound appears.  Boot logs show:

[   30.948427] HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
[   30.958108] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[   30.968030] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   31.192916] input: HDA Intel MID Line In at Ext Rear Jack as 
/class/input/input3
[   31.204980] input: HDA Intel MID Mic at Ext Front Jack as 
/class/input/input4
[   31.218872] input: HDA Intel MID Line Out at Ext Rear Jack as 
/class/input/input5
[   31.234356] input: HDA Intel MID HP Out at Ext Front Jack as 
/class/input/input6

followed later by

[   50.875374] hda-intel: Invalid position buffer, using LPIB read 
method instead.
[   50.875416] hda-intel: IRQ timing workaround is activated for card 
#0. Suggest a bigger bdl_pos_adj.


I tried backporting (forward porting?) the missing fixups from the older 
patch, but apart from adding the message:

[   30.968039] Do fixup for Poulsbo <6>D0 or newer stepping

I still didn't work (of course the possibility I stuffed up my patching 
looms large there, and I'd rather work with virgin source if it's possible).

What's the best way to go about debugging this?  Is there an official 
(or unofficial) patch for Poulsbo on 2.6.30 knocking around somewhere?

Tony
