Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbZE3Lky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbZE3Lky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZE3Lkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:40:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34232 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZE3Lkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d8ZyoYTlxM8/KBCye3bZwlIul7oopmWZoT+mqnHseWnOjbnxvfc3zcLmcOZVCnLSUJ
         +5KpypTqGRrGlG/ET039TG4XebNi7nKuS1O8N/tIVtgLAUIZh1SzuModTwGWMUiX0XKZ
         NzDs+08VrJ2E4fg15VvvqNU0XddV8mIz4ImJc=
MIME-Version: 1.0
In-Reply-To: <4A210389.80101@f2s.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	 <1243279681-4233-2-git-send-email-philipp.zabel@gmail.com>
	 <4A210389.80101@f2s.com>
Date: Sat, 30 May 2009 13:40:47 +0200
Message-ID: <74d0deb30905300440g18f525afkdae2cc3913c70b0f@mail.gmail.com>
Subject: Re: [PATCH 1/5] MFD,mmc: tmio_mmc: make HCLK configurable
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: ian@mnementh.co.uk
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@openedhand.com>,
       Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 11:59 AM, Ian molton <spyro@f2s.com> wrote:
>
> Acked-by: Ian Molton <spyro@f2s.com>

Thanks.

> However I'd like to see the clk API  weaned of its CPU spcific dependencies
> so that it can be used for this purpose instead.

Yes, I'm right with you on that.

> I consider ASIC3 support in this driver more important and this change is
> pretty noninvasive. Converting to the clk api in future shouldnt be any
> harder with this patch (actually slightly easier).

I'll try to add ASIC3 clock support in a way that it'll be easy to
convert to a architecture-independent struct clk in the future.

regards
Philipp

> Philipp Zabel wrote:
>>
>> The Toshiba parts all have a 24 MHz HCLK, but HTC ASIC3 has a 24.576 MHz
>> HCLK
>> and AMD Imageon w228x's HCLK is 80 MHz. With this patch, the MFD driver
>> provides the HCLK frequency to tmio_mmc via mfd_cell->driver_data.
>>
>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
>> Cc: Samuel Ortiz <sameo@openedhand.com>
>> Cc: Pierre Ossman <pierre@ossman.eu>
