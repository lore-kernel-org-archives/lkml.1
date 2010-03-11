Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0CKNM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:12:28 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:46287 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab0CKNM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V1LnHZDGx6WY1JT+U5oQzRdhZhzmsTQvrB2CfNCBCG+iaohQ2xHQyjOKShODQlVS2y
         ip3k6xcYDyNW0lqHO/m52ExDsWTjw/qWo4B1LQhRIlTztjIihLYhDRhJ2zR39ks6f4zg
         qbcBhzX5i8eE206jj3Dk9fxH/phoBltzNUTh8=
MIME-Version: 1.0
In-Reply-To: <20100308103108.GF28972@buzzloop.caiaq.de>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com> 
	<19346.6765.457769.167118@pilspetsen.it.uu.se> <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com> 
	<20100306104131.GV28972@buzzloop.caiaq.de> <25ae2d691003061705l5fc0bca7n4a07f558a0c410cf@mail.gmail.com> 
	<20100308095337.GB27502@pengutronix.de> <20100308103108.GF28972@buzzloop.caiaq.de>
From: dave b <db.pub.mail@gmail.com>
Date: Fri, 12 Mar 2010 00:10:37 +1100
Message-ID: <25ae2d691003110510pb19a74an337e764e54e9522f@mail.gmail.com>
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
To: Daniel Mack <daniel@caiaq.de>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/8 Daniel Mack <daniel@caiaq.de>:
> On Mon, Mar 08, 2010 at 10:53:37AM +0100, Uwe Kleine-König wrote:
>> On Sun, Mar 07, 2010 at 12:05:21PM +1100, dave b wrote:
>> > Ok... however how should one test the memory of an arm machine? ...
>> > memtest is only for x86. *I am referring to the kernel memtest and not
>> > memtest86.
>> The easiest is:  rerun make and check if it fails at exactly the same
>> place.
>
> Hmm, I wonder whether this is in any way related to what Pavel and Cyril
> reported in the 'bit error' thread.
>
> Dave, does your bootloader have any memory test built-in? Do you see the
> same issues with any older kernel?
>
> FWIW, we're currently hunting a strange bug with hanging tasks, which
> only seems to affect systems with Wifi enabled. That might be totally
> unrelated to both of these issues though.
>
> Daniel
>

U-boot apparently has a very simple memory checker, this doesn't help
me as I don't have serial access. I have now re-compiled the 2.6.33
kernel whilst the device has been on the 2.6.33 kernel 4 times now
*without* an *error*. I also ran memtester for a while using most of
the memory on the device, without invoking the oom killer.

I will re-run these tests on the 2.6.32.7 kernel soon.
