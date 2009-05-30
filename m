Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZE3XD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZE3XD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZE3XDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:03:52 -0400
Received: from luminismail.carleton.ca ([134.117.2.27]:43456 "EHLO
	luminismail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZE3XDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:03:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=utf-8
Message-id: <4A21BB4F.9000000@superonline.com>
Date: Sat, 30 May 2009 19:03:43 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bug #13377] Microphone no longer works on Toshiba Satellite A100
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
 <LEcEO2518_I.A.kbD.vIbIKB@chimera>
In-reply-to: <LEcEO2518_I.A.kbD.vIbIKB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).

Hello,

I am sorry for responding to your e-mail late. Takashi Iwai identified
the cause of this problem and provided a patch. I tested the patch and
confirmed that it solves the problem. The patch was integrated into
mainline with the following commit:

=== 8< ===
commit 461c6c3a0a23a8fac1a4b636e93ff5dfe599a241
Author: Takashi Iwai <tiwai@suse.de>
Date:   Mon May 25 08:06:02 2009 +0200

    ALSA: hda - Add missing check of pin vref 50 and others in Realtek codecs
    
    Some Realtek codecs like ALC861 seem to support only VREF50 while the
    current driver assumes it's only VREF80.  Check other VREF bits to set
    the correct value.
    
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
=== >8 ===

Regards,

M. Vefa Bicakci

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13377
> Subject		: Microphone no longer works on Toshiba Satellite A100
> Submitter	: M. Vefa Bicakci <bicave@superonline.com>
> Date		: 2009-05-24 15:49 (7 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=23f0c048ba59ad5c2f3fd85ed98360b631dbf6f8
> References	: http://marc.info/?l=linux-kernel&m=124318383910011&w=4
