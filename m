Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYAVJrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYAVJrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbYAVJrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:47:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:53540 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbYAVJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MuGPkDZqXW9xMPG5aIBmFL5IOsmMK/AiAf9y0q2iBbz9YTP7qNBEKQQYm7js745d1OoEzXnVkh9LXyDejuH7aWEKdzLo3oOOP8ce6VDjB7aZxUh0dmdhhqUc8cLFOALg4tNR2K8iT8nmZzaOV2ol9VN2SQIdiszKpzGnNB4jXWI=
Message-ID: <38b2ab8a0801220147g15aba253g663a697c80b90397@mail.gmail.com>
Date: Tue, 22 Jan 2008 10:47:22 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Vojtech Pavlik" <vojtech@suse.cz>
Subject: Re: Linux and remote control device
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080122081931.GC5591@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
	 <20080122081931.GC5591@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 9:19 AM, Vojtech Pavlik <vojtech@suse.cz> wrote:
> On Tue, Jan 22, 2008 at 09:01:10AM +0100, Francis Moreau wrote:
> > Hello,
> >
> > I'd like to add support for my Infrared remote control to Linux.
> >
> > So far I only see LIRCD project that make the kernel support
> > such device but I'm not sure if this project is the best choice
> > since it's not part of mainline kernels. And there are certainly
> > good reasons which I'm not aware of.
> >
> > Another possibility is to make the remote controle device an input
> > device. But I see several flaws:
> >
> > - The IR receiver on my board can't be use as a transmitter any
> > more
>
> The input subsystem moves events in both directions. It would need some
> additional hacking to work with IR transmitters, but it might be
> possible.
>
> > - All scancodes are embedded in the kernel.
>
> While they reside in the kernel, they can be changed from userspace.
>
> > Do you think it's still the way to go despite the 2 points raised above ?
>
> It might be, but I'm not 100% convinced either.
>

All your answers sound good however.

Could you please tell me why you're not sure ?

-- 
Francis
