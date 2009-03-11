Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZCKPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZCKPDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZCKPDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:03:34 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:53223 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZCKPDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l2Lg3x3FxJpFdLQ6jEU5jIeP40Ft196HWWKziER3KWuEa0oSWew3P1mNeAK+7Ok1Pe
         ZOaqJi1jq42lw5BoZwwdtisLHeqhlfbpKd5oHkaJEaCeYGKU+H8aFB6g077E18C6vYaf
         lx7QNgo1S3rwTH2SxG5BI9HTLTwAeZIblecLQ=
MIME-Version: 1.0
In-Reply-To: <200903111600.05835.wolfgang.mues@auerswald.de>
References: <87a5b0800903110738h508aae87y7fc462d30cc89c7f@mail.gmail.com>
	 <200903111600.05835.wolfgang.mues@auerswald.de>
Date: Wed, 11 Mar 2009 15:03:30 +0000
Message-ID: <87a5b0800903110803k5e8a8ee4m50c572d845a38cb0@mail.gmail.com>
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

On Wed, Mar 11, 2009 at 3:00 PM, Wolfgang Mües
<wolfgang.mues@auerswald.de> wrote:
> Will,
>
> Am Mittwoch, 11. März 2009 schrieb Will Newton:
>> Are they using the same host controller? Have you tried these cards
>> with a different host controller?
>
> I have tried with 3 different spi host controllers.
>
>> Are you clocking them particularly slow or fast?
>
> 400 KHz, 20 MHz and 25 MHz.
>
>> A logic probe may not display any signal integrity issues you might have.
>
> My "logic probe" is a 1 GHz leCroy DSO.
>
> I am doing this for money, and I am no amateur.

Ok, sure, but these are things that are best put in your changleogs so
people can understand what hardware is problematic and how it is
proven.

I have not seen these problems or seen them reported by others.
Hopefully they will speak up and confirm your results.
