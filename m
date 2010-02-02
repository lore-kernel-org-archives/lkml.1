Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0BBOwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:52:21 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:42303 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0BBOwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:52:19 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 2 Feb 2010 15:52:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Andreas Mohr <andi@lisas.de>, Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
References: <20100129185434.GH19501@one-eyed-alien.net> <20100202121116.GA24926@rhlx01.hs-esslingen.de> <4B6839E9.1040407@ladisch.de>
In-Reply-To: <4B6839E9.1040407@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021552.19286.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Februar 2010 15:42:49 schrieb Clemens Ladisch:
> > Or... usb-audio? I should have verified that it is using bulk endpoints
> > (and thus the patch applies to my case).
> > usb-audio probably uses isochronous transfers, thus that would be
> > an obvious reason why the patch didn't work for me.
> 
> snd-usb-audio indeed uses isochronous transfers, but those buffers are
> never mapped into user space.  The intermediate vmalloc()ed buffer is,
> however, and there was a bugfix for this recently.  Do you have these
> patches in your tree?

Now that I think about it, several video drivers do map it to user space.

	Regards
		Oliver
