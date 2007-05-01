Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbXEAOhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbXEAOhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXEAOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:37:05 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:38434 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXEAOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=JzG82N3PmQb2qq4v7z5YHLoVgl3z5N2HU0PtnBtzFhUU7blvhIsdQhLUSBeDZzELSHUntCyUWVzJFK0bsV/yoe2JPpHTeTbTKKjnkid7vUlPBehZslfjLHyCBCDmvFYRtJXrboz6HGEynP0rGhtsFI7C/JDnyS2gwI5LhR819u0=
Date: Tue, 1 May 2007 17:36:57 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1068016897.20070501173657@gmail.com>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       <kernel-discuss@handhelds.org>
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
In-Reply-To: <46374645.2030900@gmail.com>
References: <1354376306.20070501080806@gmail.com> <46374645.2030900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

Tuesday, May 1, 2007, 4:53:09 PM, you wrote:

> Hi Paul,

> Paul Sokolovsky wrote:
>> In contemporary systems, lots of functionality oftentimes handled by various
>> kinds of SoCs (system-on-chip), representing a number of deversified
>> controllers packaged in one chip. 

> I think your referring to the term "SoC (system-on-chip)" is confusing
> (at least for me). You rather consider companion chips than SoCs.

> Yes, any chip integrating a number of controllers could be considered
> as a system-on-chip but if the chip doesn't make sense without
> some master chip (processor) I'd consider the chip as a companion
> (to the processor) chip.

        Ditto for me - I find "companion" thing confusing. What's
important for the RFC/topic discussed is that it is integrated
controller with many diversified functions, not what it is helper to
something. I understand that for many people SoC means CPU with ties,
but IMHO, it's less stretch to take such chip, remove CPU, and still
call it a SoC, than call an integrated audio/touchscreen controller a
companion chip (well, of course it is; and RAM chip too ;-) ).

        Either way, I don't pledge to be a HW designer with
contemporary lexicon. The aim was simple - as a single word would be
too ambiguous, general, or vice-versa, omitting, then acronym is
needed, hopefully existing, and not new, and SoC is the most fitting
TLA, IMHO. But I'm open to specific suggestions for improvement. For
example, if I was to write a Documentation/ entry for that, I'd mention
companion chips, peripheral/integrated controllers, etc. But renaming
drivers/soc/ to drivers/companion/ would be more confusing, as the
concept described is not tied to companion chips per se (even though
many of chips we (handhelds.org) deal with, can be classified as
such).


> Regards,
> Dmitry


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

