Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYHaPfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYHaPfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 11:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYHaPfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 11:35:07 -0400
Received: from japan.chezphil.org ([77.240.5.4]:5960 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbYHaPfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 11:35:06 -0400
X-Greylist: delayed 2649 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2008 11:35:06 EDT
To: "Krzysztof Helt" <krzysztof.h1@poczta.fm>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <sylvain.meyer@worldonline.fr>,
       <linux-fbdev-devel@lists.sourceforge.net>
Date: Sun, 31 Aug 2008 15:50:54 +0100
Subject: Re: [Linux-fbdev-devel] [PATCH] intelfb: support 945GME (as used in
	ASUS Eee 901)
Message-ID: <1220194254502@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <20080831092722.c80c73c5.krzysztof.h1@poczta.fm>
References: <20080831092722.c80c73c5.krzysztof.h1@poczta.fm>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_utscv_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt wrote:
> On Fri, 29 Aug 2008 12:50:45 +0100
> "Phil Endecott" <phil_utscv_endecott@chezphil.org> wrote:
>
>> The following patch adds support for Intel's 945GME graphics chip to
>> the intelfb driver.  I have assumed that the 945GME is identical to the
>> already-supported 945GM apart from its PCI IDs; this is based on a quick
>> look at the X driver for these chips which seems to treat them
>> identically.

[snip]

>> -#define SUPPORTED_CHIPSETS	"830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM"
>> +#define SUPPORTED_CHIPSETS  "830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM"
>>  
>
> Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
>
> BTW, Is it possible to shorten this list by something like "830/845/852/865/915/945/965 models G, GM and GME" or 
> "830M/8x5G/8x5GM/9x5G/9x5GM/9x5GME" or maybe something else?

Doing so would reduce grep-ability.  I did a lot of "grep -r 945GM ." 
while trying to understand this.


Phil.



