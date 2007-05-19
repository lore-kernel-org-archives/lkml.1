Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbXESWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbXESWdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbXESWdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:33:24 -0400
Received: from neon.samage.net ([85.17.153.66]:49180 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbXESWdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:33:23 -0400
Message-ID: <4764.81.207.0.53.1179613997.squirrel@secure.samage.net>
In-Reply-To: <464F4A58.2050607@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
    <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>
    <464F4548.6020101@gmail.com> <464F4A58.2050607@gmail.com>
Date: Sun, 20 May 2007 00:33:17 +0200 (CEST)
Subject: sd_resume redundant?  [was: [PATCH] libata: implement 
     ata_wait_after_reset()]
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: c74461a82029b6293650421ecb57b64a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 21:04, Tejun Heo wrote:
> Tejun Heo wrote:
>> Yeah, if SCR registers are accessible, 0xff doesn't indicate the device
>> isn't there, so the whole skip-0xff logic probably shouldn't apply in
>> such cases, but we can also achieve pretty good result by just making
>> the first reset tries a bit more aggressive.
>
> So, here's the patch.
>
> Paul, can you please test this patch without the previous patch?  Indan,
> this should reduce the resume delay.  Please test.  But you'll still
> feel some added delay compared to 2.6.20 due to the mentioned
> suspend/resume change.

This removed the COMRESET errors indeed, and with sd_resume()
disabled everything is speedy again (2s or so. Still a desktop pc).
I didn't try with sd_resume enabled.

Everything seems to work fine without sd_resume(), so why is it needed?

Greetings,

Indan


