Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbXEUQfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbXEUQfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXEUQfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:35:18 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:35229 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755627AbXEUQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:35:16 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Mon, 21 May 2007 09:34:58 -0700
User-Agent: KMail/1.9.6
Cc: "Jon Smirl" <jonsmirl@gmail.net>, "Jesse Barnes" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com> <200705210914.22663.jbarnes@virtuousgeek.org>
In-Reply-To: <200705210914.22663.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705210934.58559.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Jesse Barnes wrote:
> > There is more to fbdev than mode setting. It is also how non-x86
> > platforms achieve their boot display. How will boot display be handled
> > with the your design? What about console display on non-x86 platforms?
> > Loading both fbdev and the new code puts us right back into the
> > multiple driver fight we have today.
>
> Maybe you should take a look at the patches. :)  The code I posted
> actually creates an fb device as a slave of the DRM device, and uses
> that for the boot console.  Once you've booted, you can use the new
> interfaces to do whatever you want with the graphics device... though it
> doesn't create /dev/fb* devices per-CRTC like you seem to want, it's
> really easy to do the equivalent with a small userspace program (though
> I haven't actually tested sharing of buffer objects, it should work).

Actually, scratch that last bit.  I forgot about a recent change alanh 
committed that did just that:  per-CRTC FB devices.  So please take a 
close look (modesetting-101 of mesa/drm git at freedesktop.org) and let me 
know if you see any gaping holes.

Thanks,
Jesse
