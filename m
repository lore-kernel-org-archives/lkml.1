Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYLaSGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYLaSGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbYLaSFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:05:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:55737 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbYLaSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:05:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wMlXtj4X6W5hTzdE6O1ouQhA2uNMFlkklBjDK8fhKG5AGHO+Nf3r6cdCpWhO42jul1
         7xefR1hxtWUwylGvUmFa8hiawmp4EwL79C8/0f1ONs9mPq8oPADzKbBOZeYoo0M78IYV
         Gf8J/rbLs6dyYulV4hNfPzAR8ajs50xDVobwE=
Message-ID: <45a44e480812311005k709c410ao1116187e9427e452@mail.gmail.com>
Date: Thu, 1 Jan 2009 02:05:50 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "David Brownell" <david-b@pacbell.net>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <200812311238.13810.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <200812302355.45193.rgetz@blackfin.uclinux.org>
	 <45a44e480812302058k365eddcfxf902095657b78534@mail.gmail.com>
	 <200812311238.13810.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2009 at 1:38 AM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Tue 30 Dec 2008 23:58, Jaya Kumar pondered:
>> On Tue, Dec 30, 2008 at 11:55 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>> > Yeah, I hadn't thought about spanning more than one gpio_chip. That's a good
>> > point.
>>
>> The currently posted code already supports spanning more than one gpio_chip.
>>
>
> But doesn't do all the other things that David suggested/requested.
>

Hi Robin,

Yes, you are right. My implementation does not support a driver that
needs to set/get more than 32-bits of gpio in a single call. I'm okay
with that restriction as I don't see a concrete use case for that. I
understand that you're saying that's not satisfactory. I guess we'll
have to agree to differ.

Thanks,
jaya
