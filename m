Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYFRKF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYFRKF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYFRKFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:05:19 -0400
Received: from mail.atmel.fr ([81.80.104.162]:57869 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYFRKFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:05:17 -0400
Message-ID: <4858DDC1.6080802@atmel.com>
Date: Wed, 18 Jun 2008 12:04:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>
CC: Marc Pignat <marc.pignat@hevs.ch>, Eric BENARD <ebenard@free.fr>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       =?ISO-8859-1?Q?Hans-J=FCrgen_?= =?ISO-8859-1?Q?Koch?= 
	<hjk@linutronix.de>
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
References: <483FE9E7.7020707@atmel.com>	<20080609124623.5b6bda48@mjolnir.drzeus.cx>	<484E4F61.7010007@atmel.com> <20080614182831.0360bd77@mjolnir.drzeus.cx>
In-Reply-To: <20080614182831.0360bd77@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Tue, 10 Jun 2008 11:54:41 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Russell King highlights that patch #4 is not well inserted in the series 
>> : it have to be after #5 (after correcting bytes_xfered update).
>>
>> If you want I can reorder them... or you manage to do it.
>>
>> I will take into account Marc's comment and new Ville patch series in 
>> another round ;-)
> 
> Will you redo this series, or are you planning further patches? (i.e.
> should I merge this set or wait for an update?)

You can merge this patch series (7 patches)

You can also merge
http://lists.arm.linux.org.uk/lurker/message/20080610.092729.beef9e64.en.html
"at91_mci: manage cmd error and data error independently" (1 patch)

And 3 patches from Ville Syrjälä that I have just signed:
http://lists.arm.linux.org.uk/lurker/message/20080614.172720.dd0e776e.en.html
"at91_mci: AT91SAM9260/9263 12 byte write erratum (v2)"


http://lists.arm.linux.org.uk/lurker/message/20080609.190644.3f64ff91.en.html
"at91_mci: Cover more AT91RM9200 and AT91SAM9261 errata."


http://lists.arm.linux.org.uk/lurker/message/20080609.190645.2998e511.en.html
"at91_mci: Fix byte mode transitions."

=> 11 patches.

Thanks a lot, regards,
-- 
Nicolas Ferre

