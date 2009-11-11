Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZKKGRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZKKGRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZKKGRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:17:33 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52124 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZKKGRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QqZyBQvmvpttgoorjkkQELte4HTWroOUsECneTOb4IHTsfeVYNrl3GQHzKa6k8lgsX
         Ku9zZcWdhmEkCrR2e2P2NuXRW2z+Hmh7lhhQs2t+EqJXeShemqtZKwInm7iZPjZa5xYj
         HCqxqHArns2Q/zT2OJLmlm1k3MpdOzrYGqkL0=
MIME-Version: 1.0
In-Reply-To: <1257842597.29038.162.camel@dax.rpnet.com>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
	 <1257809705.29038.82.camel@dax.rpnet.com>
	 <90b950fc0911091926v32dc1c44n1018322390282bc0@mail.gmail.com>
	 <1257842597.29038.162.camel@dax.rpnet.com>
Date: Wed, 11 Nov 2009 15:17:36 +0900
Message-ID: <90b950fc0911102217o41aea871u3a5d9e44c947fe3c@mail.gmail.com>
Subject: Re: [patch] added brightness feature to lcd class.
From: InKi Dae <daeinki@gmail.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's my comment below.

thank you.

2009/11/10 Richard Purdie <rpurdie@linux.intel.com>:
> On Tue, 2009-11-10 at 12:26 +0900, InKi Dae wrote:
>> Thank you for your comments.
>>
>> it is a good idea that lcd driver registers interfaces to lcd class
>> and backlight class.
>> but I think for AMOLED LCD Panel, backlight couldn't be real device so
>> power on/off
>> for backlight device doesn't make sense.
>
> The backlight power control can just turn the backlight level down to
> its lowest setting (off)?

>> I had tried lcd driver registers interfaces to lcd class and backlight
>> class as you said.
>> and also backlight fake driver as Pavel said.
>
> So you've tried this, what was the problem? Perhaps post this driver
> code to illustrate your problem?

all the cases worked fine.
it's not whether lcd driver has a problem or not.
I mean it's design issue of lcd class. AMOLED LCD Panel DOESN'T NEED
backlight device.
and I should have added brightness control feature to AMOLED LCD Panel
driver not using backlight class
because they have no BACKLIGHT DEVICE.

in point of view AMOLED LCD Panel, brightness control is perfomed by
gamma setting, not backlight power controlling.
