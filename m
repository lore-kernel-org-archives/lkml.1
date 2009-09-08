Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZIHXCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZIHXCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZIHXCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:02:05 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:51685 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbZIHXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:01:49 -0400
Message-ID: <4AA6E21C.9030909@t-online.de>
Date: Wed, 09 Sep 2009 01:00:44 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: "Carlos R. Mafra" <crmafra2@gmail.com>
CC: Linus Torvalds <torvalds@osdl.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org,
       intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after	2.6.31-rc8-git1,
 DVI connector ok
References: <4AA6D858.6040505@t-online.de> <20090908222821.GA10175@Pilar.aei.mpg.de>
In-Reply-To: <20090908222821.GA10175@Pilar.aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: rAQjb+Z6rhs-UiC74tyLT-HDmvR81KHoBVyjwzfaoe-xMmuRrnAWVGsnBZPhszWZBa
X-TOI-MSGID: f0a549b6-10f1-42d2-b8eb-81aea8e1ce3b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos R. Mafra schrieb:
> On Wed  9.Sep'09 at  0:19:04 +0200, Knut Petersen wrote:
>   
>> Hi everybody!
>>
>> During the release cycle of the 2.6.31-rc* kernels KMS started to work
>> on my computer.
>>
>> Booting with a monitor attached to both the VAG and the DVI connectors,
>> kernel 2.6.31-rc8-git1
>> detects both monitors correctly and sets the native video mode.
>>
>> Booting the same configuration with kernel 2.6.31-rc8-git2 ... -rc9-git1
>> gives a different result:
>> the DVI-attached monitor is still working perfectly, the VGA-attached
>> monitor does not detect a
>> valid video signal and switches off.
>>     
>
> I had a similar problem between -rc8 and -rc9, and the patch here
>
> http://marc.info/?l=linux-kernel&m=125239311508274&w=2
>
> fixed it for me.
>
>   

I tested that patch with kernel 2.6.31-rc9-git1 and it solves my problem.

Carlos, Jesse: Thanks a lot for that quick response!

cu,
 Knut
