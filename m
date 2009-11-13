Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbZKMUn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbZKMUn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbZKMUn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:43:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:34956 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757548AbZKMUnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:43:55 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1966R8Len96wRLquS8EFNLrgDNPdkUCYgxkcThHrS
	/9uPX0FoNyrE1a
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 2/3 v2] lirc driver for Windows MCE IR transceivers
Date: Fri, 13 Nov 2009 21:43:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc7-sidux-amd64; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200910200956.33391.jarod@redhat.com> <200910201000.00372.jarod@redhat.com>
In-Reply-To: <200910201000.00372.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911132143.59064.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for trying to get lirc mainline. Hoping that no real complaints 
against it arise, what about submitting the tree to linux-next, so it gets 
more testing exposure before the merge window opens for 2.6.33?

On Friday 13 November 2009, Jarod Wilson wrote:
> lirc driver for Windows Media Center Ed. IR transceivers
[...]
> Index: b/drivers/input/lirc/Kconfig
> ===================================================================
> --- a/drivers/input/lirc/Kconfig
> +++ b/drivers/input/lirc/Kconfig
> @@ -11,6 +11,10 @@ menuconfig INPUT_LIRC
>  
>  if INPUT_LIRC
>  
> -# Device-specific drivers go here
> +config LIRC_MCEUSB
> +	tristate "Windows Media Center Ed. USB IR Transceiver"
> +	depends on LIRC_DEV && USB

You have obviously renamed LIRC_DEV to INPUT_LIRC just before the 
submission, but missed to do so for the individual drivers which still 
depend on LIRC_DEV and are therefore not selectable; the same applies to
[PATCH 3/3 v2] lirc driver for SoundGraph iMON IR receivers and displays.

> +	help
> +	  Driver for Windows Media Center Ed. USB IR Transceivers
>  
>  endif

Regards
	Stefan Lippers-Hollmann
