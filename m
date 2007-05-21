Return-Path: <linux-kernel-owner+w=401wt.eu-S1763654AbXEUSo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763654AbXEUSo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbXEUSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:44:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:14598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbXEUSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F26SCmLNaHEbcrx81PtKX/kFfDJaOGGP9ri7qC36LY7GYKs/DtdvYORY1KH/JWo+Ro7MtvIT5oLJoXn1RCFwBvNrcCxzEXWhu5k+nM7Q/xdTt0+uDyFDw7XRB3xQc8JGntV+nm/OE5hfHMQNIWNY+q7mNOCBGjLu9og/a5lzESE=
Message-ID: <21d7e9970705211144j219fa8f5n3e5ceab90f7d3f0b@mail.gmail.com>
Date: Mon, 21 May 2007 19:44:10 +0100
From: "Dave Airlie" <airlied@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <9e4733910705211104u143e7abercccc4f351441343e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <9e4733910705211042o8926e4cy2225c2dbcbf3ff2@mail.gmail.com>
	 <21d7e9970705211047n2328f970ref96ea85856f3ba8@mail.gmail.com>
	 <9e4733910705211104u143e7abercccc4f351441343e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> You are describing a transition plan without knowing what the final
> design is going to look like. We really need to hash out the final
> design so that the right path is taken to get there.
>
> For example I didn't have per CRTC device nodes or user space consoles
> in my original design, but after talking to some of the people that
> really wanted the multi-seat feature it led me down the user space
> console path and to the per CRTC device node solution. I also got beat
> up at OLS by people wanting full Unicode support on the console.
>

No we are defining steps towards improving the drivers on Linux, the
first step is the requirement to fix suspend/resume, and allow
modesetting on multiple crtc/output combinations, the other goals are
not directly within the scope of this work, you can take steps to do
get where we want, but we don't need to move all drivers at once to
get there... we also can't just merge something like that to the
kernel...

Your old ideas were mostly limited by the fact that you didn't get the
crtc/output distinction and persisted with the idea of heads which put
policy in the kernel, this was a major failing you never discovered,
and I didn't probably look enough at the time, since then Keith
Packard has done a lot of work on randr 1.2 to show the path to what
we actually wanted.

Dave.
