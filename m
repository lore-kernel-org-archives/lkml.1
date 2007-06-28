Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbXF1GIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbXF1GIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXF1GIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:08:09 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:54629 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbXF1GIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:08:09 -0400
Message-ID: <46835047.8080600@kernel.org>
Date: Wed, 27 Jun 2007 23:08:07 -0700
From: Josh Triplett <josh@kernel.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: dave young <hidave.darkstar@gmail.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>	 <20070627180552.GA746@pe.Belkin>	 <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr> <a8e1da0706272300q3aee30der5349e85055f62a8e@mail.gmail.com>
In-Reply-To: <a8e1da0706272300q3aee30der5349e85055f62a8e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dave young wrote:
> 2007/6/27, Jan Engelhardt <jengelh@computergmbh.de>:
>> On Jun 27 2007 14:05, Chris Shoemaker wrote:
>>> What I'd really like to see is, _why_ is trailing whitespace
>>> considered harmful?
>> Consumes bytes you'll never see :)
>>
>>> Something about MUAs not preserving it or something?
>> Well, there is format=flowed. text/plain mails with a trailing blank at the end
>> of line indicates the paragraph continues -- as a curtesy for mail readers with
>> non-fixed-font to display the paragraph coherently rather than breaking it at
>> 72/80 columns.
>>
>>
>>         Jan
>> --
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> There's more potential to cause  lines end with whitespace. How about
> remove the "Some editors with ..."  like this :
> 
> +Do not leave trailing whitespace at the ends of lines.
> +
[...]

Many other causes for trailing whitespace exist.  However, I wanted to mention
one of the common causes.  If you have other common causes in mind, and even
better if you have ways to avoid them, we should add those too.

It might make sense to put a paragraph break after the first sentence, though,
and split the information about editors into its own paragraph, adding more
paragraphs if people suggest other possibilities.

- Josh Triplett
