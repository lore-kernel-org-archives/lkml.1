Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbZJNKjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbZJNKjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbZJNKjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:39:18 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:62242 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbZJNKjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qwboaTAn/QvO3vWjTLvdX9tse4rGu7FDNDPM4/vPJdDhrm2VUjN3JZ2oZlBOzzNZMh
         A9E75u9tkgGNHzM6tQU5tMgCw4vdw+AAgOm1lsckxC4YmB1hJ7q3xGQ4OZ8YvO+miQlT
         H5UqgGAFq/0z3lPbout8Lyh5vkq26+PjQtTBQ=
MIME-Version: 1.0
In-Reply-To: <20091014075919.GD5318@core.coreip.homeip.net>
References: <20091007061701.GA7567@july>
	 <359ed6810910130335m45919d6ala921d4cbfa5a341a@mail.gmail.com>
	 <5d5443650910130413t6ecd3d54p214d8f80972ed128@mail.gmail.com>
	 <20091014075919.GD5318@core.coreip.homeip.net>
Date: Wed, 14 Oct 2009 16:08:41 +0530
Message-ID: <5d5443650910140338y38be86bdpfc819f0d2a7e915@mail.gmail.com>
Subject: Re: [PATCH 1/6] Haptic: add haptic class
From: Trilok Soni <soni.trilok@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, Oct 14, 2009 at 1:29 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Oct 13, 2009 at 04:43:43PM +0530, Trilok Soni wrote:
>> Hi Kyungmin, Dmitry,
>>
>> On Tue, Oct 13, 2009 at 4:05 PM, Jani Nikula
>> <ext-jani.1.nikula@nokia.com> wrote:
>> > On Wed, Oct 7, 2009 at 09:17, Kyungmin Park <kyungmin.park@samsung.com> wrote:
>> >> New haptic class support.
>> >> This class handles the haptic devices.
>> >
>> > I'm wondering why a haptic class is needed when there is force
>> > feedback support. Admittedly, I don't know the force feedback
>> > implementation too well, but could someone please enlighten me on
>> > this? Am I missing something here?
>> >
>> > I see haptics as simple force feedback, just with (usually) small
>> > force and short duration. There are devices out there doing haptics
>> > using vibra motors, which I think would be limited if implemented
>> > using this haptics class driver. Would it be somehow problematic
>> > interfacing with the simple haptic hardware using the force feedback
>> > API?
>>
>> Please share your inputs on ff_device usage instead of haptics class.
>> I think Dmitry could add some points here as I don't see much users of
>> ff_device and I don't see any embedded device (like mobile) using it.
>>
>
> Using ff_device was considered when Jiri Slaby was trying to merge
> PHANTOM driver, bit for that device FF infrastructure was too limited
> and this it was decided that phantom would need a special userpsace that
> knows what it is and how to handle it.
>
> The curtrent haptic class seems to be bery limited and may be served via
> FF (constant or other effect in a single direction) but I don't know
> what kind of plans you have to extend it. I guess it warrants another
> discussion.

Probably Kyungmin is the right person to analyze the ff_device
infrastructure in input_device framework and see it fits haptics class
or not. As per me, for the mobile like applications current haptics
class should meet the needs.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
