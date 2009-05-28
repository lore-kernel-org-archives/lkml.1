Return-Path: <linux-kernel-owner+w=401wt.eu-S1764576AbZE1UgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764576AbZE1UgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763736AbZE1UgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:36:17 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:48034 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758354AbZE1UgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:36:16 -0400
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator/max1586: fix V3 gain calculation integer overflow
References: <20090528085920.GA4624@rakim.wolfsonmicro.main>
	<1243537203-4663-1-git-send-email-philipp.zabel@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 28 May 2009 22:36:07 +0200
In-Reply-To: <1243537203-4663-1-git-send-email-philipp.zabel@gmail.com> (Philipp Zabel's message of "Thu\, 28 May 2009 21\:00\:03 +0200")
Message-ID: <87ljoh2ceg.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Zabel <philipp.zabel@gmail.com> writes:

> On Thu, May 28, 2009 at 10:59 AM, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
>> On Thu, May 28, 2009 at 07:15:16AM +0200, Philipp Zabel wrote:
>>> The V3 regulator can be configured with an external resistor
>>> connected to the feedback pin (R24 in the data sheet) to
>>> increase the voltage range.
>>>
>>> For example, hx4700 has R24 = 3.32 kOhm to achieve a maximum
>>> V3 voltage of 1.55 V which is needed for 624 MHz CPU frequency.
>>>
>>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
>>
>> Looks good.
>>
>> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> Thanks, but it turns out I hit a 32 bit integer overflow in
> the gain calculation. I'd like to mend that with the following
> patch. Now max_uV could be increased up to 4.294 V, enough to
> charge LiPo cells.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
OK.

With that one melt into the previous one, have my :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Would you submit that to Liam or Mark for queuing into the regulator patch queue ?

Cheers.

--
Robert
