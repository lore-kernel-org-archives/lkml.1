Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXBKWDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXBKWDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbXBKWDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:03:31 -0500
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:35571 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbXBKWDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:03:30 -0500
Message-ID: <45CF9251.1040003@rrz.uni-koeln.de>
Date: Sun, 11 Feb 2007 23:01:53 +0100
From: Berthold Cogel <cogel@rrz.uni-koeln.de>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Regression in kernel linux-2.6.20-rc1/2: Problems with poweroff
References: <459069AA.20809@rrz.uni-koeln.de> <45999C47.40204@rrz.uni-koeln.de> <20070102190722.GT20714@stusta.de> <200702052228.34264.lenb@kernel.org> <20070206034620.GB27397@stusta.de>
In-Reply-To: <20070206034620.GB27397@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk schrieb:
> On Mon, Feb 05, 2007 at 10:28:34PM -0500, Len Brown wrote:
>>> On Tue, Jan 02, 2007 at 12:41:59AM +0100, Berthold Cogel wrote:
>>>>>> 'shutdown -h now' doesn't work for my system (Acer Extensa 3002 WLMi)
>>>>>> with linux-2.6.20-rc kernels. The system reboots instead.
>>>>>> I've checked linux-2.6.19.1 with an almost identical .config file
>>>>>> (differences because of new or changed options). For pre 2.6.20 kernels
>>>>>> shutdown works for my computer.
>> Try CONFIG_USB=n
> 
> CONFIG_USB_SUSPEND=n is most likely enough.
> 
> That's an unfixed 2.6.20-rc regression reported more than once, the 
> first time in December last year...
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=7945
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=7828
> 
>> -Len
> 
> cu
> Adrian
> 

Hi!

CONFIG_USB_SUSPEND=n does the job. But the patch from
http://bugzilla.kernel.org/show_bug.cgi?id=7828#c29 works for my system
too (with CONFIG_USB_SUSPEND=y). The bugreport was made for an ACER
Travelmate 4001 WMLi, which is almost identical to my Acer Extensa 3002
WLMi.


Regards,
Berthold

