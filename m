Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbXE0CvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbXE0CvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXE0CvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:51:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50854 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbXE0CvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:51:07 -0400
Date: Sat, 26 May 2007 19:45:56 -0700
From: Greg KH <greg@kroah.com>
To: Rodrigo Pereira <rodripe@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs permitions on class leds
Message-ID: <20070527024556.GA8405@kroah.com>
References: <114492e40705251137k53d9c341q3430710c75408b33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <114492e40705251137k53d9c341q3430710c75408b33@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 03:37:46PM -0300, Rodrigo Pereira wrote:
>  (sorry my English)
> 
>  I'm helping M?rton N?meth  in a experimental mail led driver
>  leds-clevo-mail.c for clevo laptops and I have problems with this
>  driver:
>  this files
>  /sys/class/<ledname>trigger,  /sys/class/<ledname>/dalay_on and
>  /sys/class/<ledname>/delay_off  are  created  as 644 permissions. Also
>  ROOT controls the led. I think write udev rules but my rules don't
>  change this permissions.
> 
>  The clevo mail led is a trigger led (time-trigger) for blinks the led
>  when a new mail arrives.
> 
>  How can I change the permissions of the sysfs objects in runtime or 
>  userspace?

Just do a 'chmod' on the sysfs file.  If you have the proper permissions
to do that, it will stick for as long as the sysfs file stays around.

hope this helps,

greg k-h
