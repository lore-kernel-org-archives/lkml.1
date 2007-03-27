Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbXC0QTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbXC0QTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXC0QTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:19:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:50304 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883AbXC0QTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qbDbmgsPdfLlPbneAkg5UALS/YbmQHhzI/y8GettiXY14shs4AoYYO+mpHCyd1Ynt6fLxAj6C6v74XlH2lX7KIHhXEHHY0LjaHwxkUJRU0nIcAWp7RKocfx9QQIj66lS6EEaeUYDs+PJa8ycgPLmZAP279SXDu88ua7xxCddjPs=
Message-ID: <d120d5000703270919y16ae3e56kb7d2fbd293213939@mail.gmail.com>
Date: Tue, 27 Mar 2007 12:19:10 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Fix sudden warps in mousedev
Cc: "Pete Zaitcev" <zaitcev@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Peter Osterlund" <petero2@telia.com>
In-Reply-To: <4609409F.2070203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070324001610.724a820a.zaitcev@redhat.com>
	 <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com>
	 <20070326144206.93805eeb.zaitcev@redhat.com>
	 <200703262114.45287.dtor@insightbb.com> <460934D7.9030700@redhat.com>
	 <d120d5000703270846y87e4283m4009ff0a9f65dac4@mail.gmail.com>
	 <4609409F.2070203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Dmitry Torokhov wrote:
> >>
> >> And why did the mouse numbers all get rearranged in 2.6.20, e.g.
> >> mouse1 became mouse2 for many people?
> >
> > Input devices are not guaranteed to be stable.
> >
>
> So people with z-axis mice need to redo their X config for each
> kernel release when the device numbers change? Or should they
> be using some other configuration?
>
> People using this now have X crashes on kernel upgrade because
> event1 became event2:
>
>        Driver      "evdev"
>        Option      "Device" "/dev/input/event1"
>

I'd recommend matching on "phys" or individual capabilities bits
instead of device node. See "man evdev".

-- 
Dmitry
