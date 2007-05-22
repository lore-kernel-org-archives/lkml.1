Return-Path: <linux-kernel-owner+w=401wt.eu-S1763885AbXEVSS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763885AbXEVSS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbXEVSSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:18:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60425 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbXEVSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dD+6uMiCR2XuyTBtc6L19COFcTsjkGGnjXBSpPV0rj8+PNDgTjUkqu8fTv8xh6sJUxonItX19OQJgVtfBAvwNnkMynUr3sYf60hYlWxnKxL72ibnZIBAIEotNbWqakZbkTPsZEdzfEgfPPipKjnEmpWsFwlx7mT51Q+ej5+P8/w=
Message-ID: <21d7e9970705221118x36e556fcy2e8cc91c4f07881a@mail.gmail.com>
Date: Tue, 22 May 2007 19:18:45 +0100
From: "Dave Airlie" <airlied@gmail.com>
To: "Philipp Klaus Krause" <pkk@spth.de>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <46531A55.9090403@spth.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <1179792587.32247.769.camel@localhost.localdomain>
	 <46531A55.9090403@spth.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Philipp Klaus Krause <pkk@spth.de> wrote:
> Benjamin Herrenschmidt schrieb:
> >> In collaboration with the FB guys, we've been working on enhancing
> >> the
> >> kernel's graphics subsystem in an attempt to bring some sanity to the
> >> Linux graphics world and avoid the situation we have now where
> >> several
> >> kernel and userspace drivers compete for control of graphics devices.
> >
>
> What's the difference between this and Jon Smirls' proposals from early
> 2005?
>

One of the biggest differences is we have the experience of the
randr-1.2 code in the X server and a chipset which is backed my the
manufacturer to design and test on. It also makes sure the design is
actually real-world useful, I've already deployed this modesetting
code in a standalone GL multi-head enviornment using miniglx code.

We also aim to maintain as much compatibility with the current system
as possible, whereas Jon really didn't care.

Also Jon proposed about 10 things, but never an actual API, the things
he proposed are still problems, but they are I believe as do many
others to be orthogonal problems, not the intertwined things that he
believes should be lumped under a single API ala DirectX.

Dave.
