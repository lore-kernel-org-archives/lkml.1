Return-Path: <linux-kernel-owner+w=401wt.eu-S1765543AbXJZVIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765543AbXJZVIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXJZVIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:08:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:14424 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXJZVIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PhI05BnFLVKZJDsjSq093EM9VQoA4wJgln1NChLR+zERF5lgbWyc/p1Thp+dnQUe4ggB/dVwhOhewvlOZBMpXcZXWMAte/+QZa9e3RX3NaH5MYnwcTwULe/SKbs81+IQi2WyIYqP5zZnEGqfuZVvTM9ace7IS9nYTpCTuR04bs0=
Message-ID: <47225728.2070808@gmail.com>
Date: Sat, 27 Oct 2007 01:07:52 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: arvidjaar@mail.ru, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.624-rc1 regression] lost battery information
References: <200710262024.06012.arvidjaar@mail.ru> <200710262120.22536.arvidjaar@mail.ru> <47222DF3.3040208@gmail.com> <200710262215.42939.arvidjaar@mail.ru> <472232D3.6000807@gmail.com> <E1IlWFd-0002fD-6c@faramir.fjphome.nl>
In-Reply-To: <E1IlWFd-0002fD-6c@faramir.fjphome.nl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Alexey Starikovskiy wrote:
>> Andrey Borzenkov wrote:
>>> is it in -rc1 or can you point me to the patch (I'd rather avoid having
>>> to pull from different git trees). Thank you.
>> No, it should be rc1.
>>> And what about ACPI_PROCFS case? It still needs attention I believe.
>> As you can see, there is info in /proc too:
> 
> I'm missing the info in /sys too, so it looks like the error in proc and
> the missing info in /sys are related.
> 
> Alexey: do you have POWER_SUPPLY and/or AC/BATTERY compiled in or modular?
> I wonder if that could make the difference.
> 
Currently everything is module.
