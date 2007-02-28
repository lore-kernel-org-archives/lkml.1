Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXB1Pxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXB1Pxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 10:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXB1Pxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 10:53:37 -0500
Received: from smtp107.biz.mail.re2.yahoo.com ([206.190.52.176]:44790 "HELO
	smtp107.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751954AbXB1Pxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 10:53:36 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 10:53:36 EST
X-YMail-OSG: 4FwIcdIVM1lK1sXESGxrW9vBJowOEV_o0HYJ0v.qjEOFK0.6iFoimwzZDB2_mf8iz9TEK_ZhzXV0RNHk_i62RUz_LvidUaqLbEjpXcgn2yx1ZaYZIdqR2tF.ZPuX9tWpRMmx58grgeuGX_o-
In-Reply-To: <511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>
References: <45E46976.6060600@freescale.com> <29c13109971547687159078eacdea008@kernel.crashing.org> <45E592DC.9060700@freescale.com> <511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>
Cc: Timur Tabi <timur@freescale.com>, Torben.Mathiasen@hp.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 10:46:53 -0500
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2007, at 9:54 AM, Segher Boessenkool wrote:

>>>>           46 = /dev/ttyCPM0        PPC CPM (SCC or SMC) - port 0
>>>>              ...
>>>> -         47 = /dev/ttyCPM5        PPC CPM (SCC or SMC) - port 5
>>>> +         49 = /dev/ttyCPM5        PPC CPM (SCC or SMC) - port 5
>>> If CPM0 is 46, then CPM5 is not 47, but not 49 either.
>>> Unless it's not CPM5 but CPM3?
>>
>> Honestly, I don't know.  I was just correcting the obvious typo (47
>> instead of 49).
>
> It's obvious it shouldn't be 47, but it's not obvious it
> should be 49 instead.

I don't know the origin of this thread, but none of
that looks correct.  Today, there can be up to 8
CPM UART devices, 6 on CPM/CPM2 and 8
on the QE.  If ttyCPM0 starts at minor 46, they
should be at least monotonically incrementing
up to ttyCPM7 with minor 53.


Thanks.

	-- Dan

