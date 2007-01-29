Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXA2OhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXA2OhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXA2OhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:37:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:20183 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXA2OhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cw8OeQNzkGt06xWrFLakpWIswj43D1XVDZUnRTGD5x9jQPuqWQUJMEq2L9W/2oxbZtdNwcsAGADZWRmn3uXpeuTyMMKUp7oXOMmJwYRzyvDjuawsI7pXTJq0vEFrk0eMhs220/8+9sOZ441x/5GXx42/UNzQ9FwQ3iqEcXdKV1U=
Message-ID: <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
Date: Mon, 29 Jan 2007 15:37:22 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "Andrew Morton" <akpm@osdl.org>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070128160831.fb51347f.akpm@osdl.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Dave Airlie <airlied@gmail.com> wrote:
> > > > Because most users won't even be aware of the module option: they'll just
> > > > know that their card doesn't work right.
> > >
> > > This isn't a card problem this is a monitor problem, the card just
> > > passes through the edid data from the monitor... or else the
> > > programming of the card registers from edid is wrong..
> >
> > In which case the same problem would occur with different video cards, so
> > this patch should be some generic thing, available to all drivers, no?
>
> It should be in the fb layer not card specific.. as it may happen on any card...

Although solving the problem at the fb layer level is probably the
correct/best way to do it, I am not aware of people having problems
with broken EDIDs and non-nVidia cards. By contrast, workarounds for
nVidia and broken EDIDs is a very common thing to do even on Windows.
Both the Windows and the Linux proprietary drivers need SoftEDID
specifications to work around these problems. I don't know if this is
just because of the way the driver are written, though, or if nVidia
cards are particularly unable to handle monitors with broken EDIDs.

Plus, providing an fb-layer-level solution is way beyond my kernel
programming experience :)

-- 
Giuseppe "Oblomov" Bilotta
