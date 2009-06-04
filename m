Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZFDKHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZFDKHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZFDKGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:06:48 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:57444 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbZFDKGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lWMT9b0IkZjE0psOtAPcOzmA7UYLjn1dGIUhnu1SJe/y3ms++wZzjdF1LWPpPlFbUY
         RjOln8ZgRyuGGJ+lXCx1SU3R9Cux4v9p11UwL0V7Vmr1B3rUGv4T/S08VWVivds8Pfzs
         MJp1EoTaWop67eaO8XTtUZ9zoR6tyozBfrIzY=
MIME-Version: 1.0
In-Reply-To: <200906040248.07922.david-b@pacbell.net>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
	 <200906040215.48264.david-b@pacbell.net>
	 <8bd0f97a0906040220k6f56b944n733a2b3469faaccb@mail.gmail.com>
	 <200906040248.07922.david-b@pacbell.net>
Date: Thu, 4 Jun 2009 06:06:48 -0400
Message-ID: <8bd0f97a0906040306j4c06c4efhbfa5ab47de590527@mail.gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
From: Mike Frysinger <vapier.adi@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 05:48, David Brownell wrote:
> On Thursday 04 June 2009, Mike Frysinger wrote:
>> > I don't like the idea of embedding any kind of interpreter
>> > in the sysfs interface, but that's the direction you seem
>> > to be heading ...
>>
>> i dont view the userspace GPIO interface as a simple "i want to wiggle
>> pins for fun and testing".  i see it as a dynamic method for building
>> userspace drivers for simple devices.
>
> I don't.  I see it as an adjunct to real drivers.  Or maybe
> we just differ on what "simple" means here.
>
>> as such, having a very simple
>> "command language" for optimizing the interaction provides a pretty
>> good trade off between kernel complexity and lowering overhead imo.
>
> If that's what you want, why don't you write a custom driver
> that provides the kind of command interpreter you want?

i had "simple-gpio" but it was rejected as it duplicated too much with
the gpio sysfs interface

does vectored writes (writve) work with sysfs ?  if so, then that
should work for back-to-back commands rather than having sysfs do
stream parsing.
-mike
