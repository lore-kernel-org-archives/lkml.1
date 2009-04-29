Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbZD2NTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbZD2NTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760736AbZD2NP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:15:26 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55655 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760734AbZD2NPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:15:24 -0400
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
Message-Id: <CCB52791-FFE9-487A-97E8-C902622CC162@vmware.com>
From: Jakob Bornecrantz <jakob@vmware.com>
To: Peter Hanzel <hanzelpeter@gmail.com>
In-Reply-To: <7D4BD025A2554467AD77428C455E1FE0@avitech.sk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Intel KMS + fbcon + Mplayer
Date: Wed, 29 Apr 2009 15:15:23 +0200
References: <7D4BD025A2554467AD77428C455E1FE0@avitech.sk>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 apr 2009, at 12.04, Peter Hanzel wrote:
> Hello.
>
> I have tried Intel KMS in kernel 2.6.91.1 with fbcon. I am using only
> framebuffer console.
> Most fb apps works, but I have problem with mplayer.
> The init works but the video is badly displayed.
> I have investigated the problem and found, that for my laptop mode
> 1280x800-32.
>
> The ioctl on /dev/fb0 FBIOGET_VSCREENINFO returns.
> var.bits_per_pixel=32
> var.transp.length = 0.
>
> So the mplayer thinks we are in 24 bit mode (maybe this is bug in  
> mplayer,
> because bits_per_pixel is 32).
>
> But next I have checked it with kernel vesafb and for same mode
> (1280x800-32, vga=0x362 )
> The fb ioctl returns
> var.bits_per_pixel=32
> var.transp.length = 8.
>
> So is this intentionally made so. Because I think this mode use only  
> red,
> green,blue and no transp. But for one pixel you must write 4 bytes.  
> (so
> transp is not used).

Hmm, if I remember correctly from running mplayer in the early days of  
kms mplayer has two fbdev drivers and I think that only #2 worked. It  
did worked back then but it was a long time ago. Heck it was one of  
the first things we demoed kms with.

Cheers Jakob.
