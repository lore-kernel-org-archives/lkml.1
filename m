Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZHGIM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZHGIM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbZHGIM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:12:28 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:57618 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbZHGIM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:12:27 -0400
Message-ID: <4A7BE1E7.60203@parrot.com>
Date: Fri, 7 Aug 2009 10:12:23 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: David Xiao <dxiao@broadcom.com>, Ben Dooks <ben-linux@fluff.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Robin Holt <holt@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       v4l2_linux <linux-media@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is	get_user_pages()
 enough to prevent pages from being swapped out ?")
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>	<200908061506.23874.laurent.pinchart@ideasonboard.com>	<1249584374.29182.20.camel@david-laptop> <200908070929.53873.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200908070929.53873.laurent.pinchart@ideasonboard.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart a écrit :
> On Thursday 06 August 2009 20:46:14 David Xiao wrote:
> 
> Think about the simple following use case. An application wants to display 
> video it acquires from the device to the screen using Xv. The video buffer is 
> allocated by Xv. Using the v4l2 user pointer streaming method, the device can 
> DMA directly to the Xv buffer. Using driver-allocated buffers, a memcpy() is 
> required between the v4l2 buffer and the Xv buffer.
> 
v4l2 got an API (overlay IRRC) that allow drivers to write directly in
framebuffer memory.
BTW Xv buffer is not always in video memory and the X driver can do a
memcpy.


Matthieu
