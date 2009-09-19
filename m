Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZISAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZISAKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 20:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZISAKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 20:10:17 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43483 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbZISAKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 20:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XE+ksIZF9R2i0RRTPJ4/h3Kh5hcMON/qocBSz9AiVfIw54mt28NDv3iicAR5x0fJdT
         G0c7Tqr/+aIGp2zAARpKO0BmhlCN6qQbmImkrMEs46eygCu7adz+dvhqQnVGZpj0vBFe
         SnyF/wqtSq41y8BINsWV/ZWkgvZubpKYrpCk0=
MIME-Version: 1.0
In-Reply-To: <1249529480.16688.13.camel@ben-desktop>
References: <200907311027.06370.hartleys@visionengravers.com>
	 <200908041414.26112.david-b@pacbell.net>
	 <BD79186B4FD85F4B8E60E381CAEE190901B7783E@mi8nycmail19.Mi8.com>
	 <1249529480.16688.13.camel@ben-desktop>
Date: Sat, 19 Sep 2009 08:03:28 +0800
Message-ID: <45a44e480909181703l7b1ef8a1lf00fdd53aebfb523@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 11:31 AM, Ben Nizette <bn@niasdigital.com> wrote:
> On Tue, 2009-08-04 at 20:48 -0400, H Hartley Sweeten wrote:
>
>> For the record. The reason I sent this is I'm trying to work out an
>> extension to gpiolib that adds gpio_port_* access to the API.  Most
>> of the gpiolib drivers already the necessary logic since the raw I/O
>> is performed on the entire 'chip'.  The API just needs the extensions
>> added to request/free the port, set the direction and get/set the value.
>>
>> Is this a worthwhile addition?
>
> Plenty of people seem to think so.  Personally I haven't seen a great
> use case except "'coz I can", but if you've got one I'd love to hear.

Yes, you're right that there has been no major demand for it. There
are (luckily?) only a moderate number of devices that are using gpio
as their parallel bus interface. I've been supporting the batch-gpio
patchset below out-of-the-tree because it has come in handy with a few
e-paper display controllers and LCD 8080-IO that I've been developing
with.

>
> Have you seen http://lkml.org/lkml/2009/1/25/10 ?  Donno what ended up
> happening to that patchset..
>

I didn't pursue it further and have maintained it out-of-tree. I felt
that David had concerns about the API I implemented so it was unlikely
to get merged and I didn't have the motivation to implement another.
:-)

Thanks,
jaya

ps: I'm in Portland for the festival of linux conferences this week
and would be happy to work on this/discuss alternate APIs if it is of
interest.
