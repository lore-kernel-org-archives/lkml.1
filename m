Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZGNPRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZGNPRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbZGNPRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:17:48 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57823 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZGNPRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=We6OqouKKgXmB0lWVZTi8X42k7Juh5pC/okxSGGnP9wt890a+2ZXw8BJUm72ZleD7F
         qz9XqSYfgtvaEGNI9yuxN2I5Y1aL0IlXP2oo/aIxuOJHBsJsJrQAxQyU/8l5KDQptdjD
         hvCngo0c8ACStMcKPgUixbK/Ql/0qFwiZ7Mws=
Message-ID: <4A5CA18E.70903@gmail.com>
Date: Tue, 14 Jul 2009 23:17:34 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@sirena.org.uk>, mike.rapoport@gmail.com,
       Paul Shen <bshen9@marvell.com>, Haojian Zhuang <hzhuang1@marvell.com>
Subject: Re: da9030: ldo11 ignores disable
References: <4A439A2B.2020706@cam.ac.uk> <1246009446.30631.27.camel@vega.slimlogic.co.uk> <4A44A026.3050207@cam.ac.uk> <4A4DB73A.9050803@gmail.com>
In-Reply-To: <4A4DB73A.9050803@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:
> Jonathan Cameron wrote:
>> Liam Girdwood wrote:
>>> On Thu, 2009-06-25 at 15:39 +0000, Jonathan Cameron wrote:
>>>> Hi All,
>>>>
>>>> Whilst testing a regulator machine config I've run into a weird issue.
>>>>
>>>> The preliminary data sheet I have suggests that there are two enable
>>>> registers
>>>> for ldo11 but neither rctl22 or rctl11 seems to have any effect (on
>>>> their own
>>>> or both cleared together). I can change the voltage just fine, but not
>>>> actually turn it off.
>>>>
>>>> Anyone come across this problem or have any idea what is going on?
>>> I've come across something similar in the past with two enable bits
>>> causing I2C register cache coherency issues. The cache bits became out
>>> of sync with reality and stopped some I2C writes happening.
>> Don't thing that could happen here.
>>> Another option is that your hardware config doesn't allow ldo11 to be
>>> disabled ?
>> Other than the obvious possibility that the hardware has a bug, I can't
>> seem to find a reason why this shouldn't work.
>>
> 
> I didn't meet this problem, Haojian & Paul, ever had this problem before?
> Or try lookup the Errata for the Arava chip.

Hi Jonathan,

Here's a hint, check register 0x1b - which looks suspicious to me to have
some side effects to LDO11.
