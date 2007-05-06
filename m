Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXEFMU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXEFMU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 08:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXEFMU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 08:20:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:49926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbXEFMU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 08:20:57 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Correct location for ADC/DAC drivers
To: Robin Getz <rgetz@blackfin.uclinux.org>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Stefan Roese <ml@stefan-roese.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sun, 06 May 2007 14:19:59 +0200
References: <8fZXU-3EI-11@gated-at.bofh.it> <8haHG-6zd-19@gated-at.bofh.it> <8hd2U-1Ca-39@gated-at.bofh.it> <8heii-3GM-37@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hkfia-0000cJ-18@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18ssMDOVfevOHROkIEEVP4IduNXZAl0jiMfkkN
 PuLHd8L2C7shXLDJJDu43z/XwFHWJ8dIPxWQmkEGZWKKgjrRkL
 P042c6+MWchIiLzsmAFUQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Fri 4 May 2007 16:52, Robert Schwebel pondered:
>> On Fri, May 04, 2007 at 02:21:50PM -0400, Robin Getz wrote:

>> > We also have DAC and ADC drivers (up to 16 bits @ 64MS/s, via DMA),
>> > that would be nice to put in the "right" place  - I don't think that
>> > drivers/char is the right place, nor drivers/misc - I also don't think
>> > that /adc is a descriptive place for DAC or mixed signal front ends
>> > (MxFE).
>>
>> What userspace interface do your drivers have?
> 
> Right now, it is a little rudimentary char interface, it needs a little care
> to be a bit more general purpose, but it suited needs of what the people who
> were using it.

[...]

> I would be interested in having a detailed discussion/random thoughts on
> this - what is the best way to expose these types of devices?

Since you ask for random thoughts:

IO of data streams from or to a DAC/ADC is essentially what soundcards do.
I'm wondering if these cards are similar enough to use alsa, and if using
that interface would ease or hinder programming the driver.
-- 
Top 100 things you don't want the sysadmin to say:
76. I have never seen it do *that* before...

Friﬂ, Spammer: BZmk0Kx63V@ld7M4m.7eggert.dyndns.org
