Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZHGKLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZHGKLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZHGKLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:11:43 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:53732 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZHGKLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:11:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was " 
 =?iso-8859-1?q?Is=09get=5Fuser=5Fpages?=() enough to prevent pages from being swapped out ?")
Date: Fri, 7 Aug 2009 12:13:48 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30.3; KDE/4.2.4; x86_64; ; )
Cc: David Xiao <dxiao@broadcom.com>, Ben Dooks <ben-linux@fluff.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Robin Holt <holt@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "v4l2_linux" <linux-media@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <200908070929.53873.laurent.pinchart@ideasonboard.com> <4A7BE1E7.60203@parrot.com>
In-Reply-To: <4A7BE1E7.60203@parrot.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908071213.48523.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 10:12:23 Matthieu CASTET wrote:
> Laurent Pinchart a écrit :
> > On Thursday 06 August 2009 20:46:14 David Xiao wrote:
> >
> > Think about the simple following use case. An application wants to
> > display video it acquires from the device to the screen using Xv. The
> > video buffer is allocated by Xv. Using the v4l2 user pointer streaming
> > method, the device can DMA directly to the Xv buffer. Using
> > driver-allocated buffers, a memcpy() is required between the v4l2 buffer
> > and the Xv buffer.
>
> v4l2 got an API (overlay IRRC) that allow drivers to write directly in
> framebuffer memory.

That's right, but I was mostly using this as an example.

> BTW Xv buffer is not always in video memory and the X driver can do a
> memcpy.

Still, one less memcpy is better :-)

Regards,

Laurent Pinchart

