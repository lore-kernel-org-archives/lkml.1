Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbXFVFYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbXFVFYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXFVFYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:24:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXFVFYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:24:34 -0400
Message-ID: <467B5B8A.2020306@zytor.com>
Date: Thu, 21 Jun 2007 22:18:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, david@lang.hm,
       schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>	 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>	 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org>
In-Reply-To: <1182483527.10524.31.camel@shinybook.infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
>> The main problems are not really hard to fix......
>>
>> -	Most problems eem to be related to the fact that Linux does not
>> 	use C-99 based types in the kernel and the related type definitions 
>> 	are not written in plain C. This is something that should be fixed
>> 	with a source consolidation program or by defining aliases to 
>> 	C-99 types in case the compiler is not GCC.
> 
> 
> The argument has been made that the standard C99 types are _optional_,
> and anything included from a C library's headers without _explicitly_
> being included by the user shouldn't define those types.
> 
> Personally, I think that's a load of bollocks. And it certainly doesn't
> apply to Linux-specific files like <linux/cdrom.h>, which are perfectly
> entitled to use a C standard from last millennium, regardless of
> namespace 'pollution' issues. That's why we continue to use the crappy
> __u32 types. Can you be more specific about why this is a problem? Don't
> we mostly define those crappy types using arch-specific knowledge, as
> 'int', 'long', etc?
> 

It definitely does hurt when using those types in files that may want to
be used by the C library (as opposed to the end user.)

However, there is no reason why there should be anything funny about the
declaration of those types.

	-hpa
