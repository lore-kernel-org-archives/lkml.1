Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZCKPVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZCKPVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZCKPVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:21:30 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:42116 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZCKPV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CSoEQgQ4xbgLYaANLh/8yA31m8FWwhZ6F5f1FBMzk88e81/93MMZjVItILVAtfwKGm
         DGxlacZ/8U9Fm+FMP3Btp3ZCdz/HFiB+jQIOT07bu1+KsjBCzmu8fQ8tSGu0Y4nz9DwB
         0LEfv+p+c987M0sXrY+7XjAfGYTNkdgeYVgs0=
MIME-Version: 1.0
In-Reply-To: <200903111614.19727.wolfgang.mues@auerswald.de>
References: <87a5b0800903110803k5e8a8ee4m50c572d845a38cb0@mail.gmail.com>
	 <200903111614.19727.wolfgang.mues@auerswald.de>
Date: Wed, 11 Mar 2009 15:21:26 +0000
Message-ID: <87a5b0800903110821n3b08ae2sb2e2fb4d6e9d5ab9@mail.gmail.com>
Subject: Re: [PATCH 7/7] mmc_spi: support for non-byte-aligned cards
From: Will Newton <will.newton@gmail.com>
To: =?ISO-8859-1?Q?Wolfgang_M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 3:14 PM, Wolfgang Mües
<wolfgang.mues@auerswald.de> wrote:
> Will,
>
> Am Mittwoch, 11. März 2009 schrieb Will Newton:
>> I have not seen these problems or seen them reported by others.
>
> Yes, it is hard to believe that such a design error is present in today SD
> cards. But spi mode is used only by some devices which do not have a SD host
> controller on board.

I have found some older cards that do not work well with SPI mode, but
I had written of these as ancient relics (128Mb or less in capacity).
I was under the impression that more mobile devices are using SPI mode
these days so SPI mode was becoming more of a priority for
manufacturers.

> I know a commercial FAT/SD card software package, and I found that inside
> their spi driver, there is support for non-byte-aligned cards too. So I am
> not the only one who has knowlegde about this problem.
>
> Should I send you one of these cards so you can verify this problem?

I would be interested to know the manufacturer and model number of a
couple of examples certainly, that way hopefully the test would be
truly independent.
