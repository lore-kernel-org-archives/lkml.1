Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbZKMDN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbZKMDN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 22:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZKMDNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 22:13:51 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51786 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbZKMDNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 22:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s5y7zDhkyURplQ3MdK8JG+9fXp/5sOz20/GX4ojauDjWXx5/piump44LoLeoONW9W2
         t14cmhQc5xj4czlAB10VM4xvQWc25cNXNuw4ipTkWsLVXEFC5cL572qXAwrmXahJUPsz
         +EmoqiRTvOlOKVIaLO7QCV5BWuhStiX8kXcjI=
MIME-Version: 1.0
In-Reply-To: <1257931717.29038.298.camel@dax.rpnet.com>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
	 <1257809705.29038.82.camel@dax.rpnet.com>
	 <90b950fc0911091926v32dc1c44n1018322390282bc0@mail.gmail.com>
	 <1257842597.29038.162.camel@dax.rpnet.com>
	 <90b950fc0911102217o41aea871u3a5d9e44c947fe3c@mail.gmail.com>
	 <1257931717.29038.298.camel@dax.rpnet.com>
Date: Fri, 13 Nov 2009 12:13:54 +0900
Message-ID: <90b950fc0911121913o2b5285f5w23c706aed3203e65@mail.gmail.com>
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

Ok, I understood your answer.
Just it was my idea for AMOLED LCD Panel.
Both of them (AMOLED, TFT-LCD) do same thing in terms of brightness
control as you said.

Thank you, Richard.

Best Regards,
InKi Dae.

2009/11/11 Richard Purdie <rpurdie@linux.intel.com>:
> On Wed, 2009-11-11 at 15:17 +0900, InKi Dae wrote:
>> 2009/11/10 Richard Purdie <rpurdie@linux.intel.com>:
>> > So you've tried this, what was the problem? Perhaps post this driver
>> > code to illustrate your problem?
>>
>> all the cases worked fine.
>> it's not whether lcd driver has a problem or not.
>> I mean it's design issue of lcd class. AMOLED LCD Panel DOESN'T NEED
>> backlight device.
>> and I should have added brightness control feature to AMOLED LCD Panel
>> driver not using backlight class
>> because they have no BACKLIGHT DEVICE.
>>
>> in point of view AMOLED LCD Panel, brightness control is perfomed by
>> gamma setting, not backlight power controlling.
>
> The question is whether this gamma control does the same thing as what
> we've traditionally used the backlight brightness control for. As I
> understand it, the answer is yes and to userspace making it appear as a
> backlight brightness control makes sense.
>
> The userspace view of the world is key and the fact there is not a
> traditional physical backlight in the hardware isn't really an issue.
>
> Why would we want to create two userspace interfaces doing the same
> thing which would mean we just have to complicate userspace drivers?
> Symlinking just makes things confusing.
>
> Cheers,
>
> Richard
>
>
>
