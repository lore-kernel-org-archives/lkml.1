Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZGBS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZGBS0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZGBS0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:26:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41292 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326AbZGBS0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:26:10 -0400
Date: Thu, 2 Jul 2009 19:27:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux-Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: good example of a tty driver
Message-ID: <20090702192744.029620ae@lxorguk.ukuu.org.uk>
In-Reply-To: <D77CBB49-A340-4282-9ACF-2172D1BB9E43@kernel.crashing.org>
References: <D77CBB49-A340-4282-9ACF-2172D1BB9E43@kernel.crashing.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 11:48:09 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> Alan,
> 
> Can you point me at any good drivers to use as an example of using the  
> tty layer.  I'm trying to get an out of tree driver brought up to date  
> for the Avocent ESP-16 MI Serial Hubs (serial over ethernet):

Its very much in flux with the drivers getting kref support, helper
functions and the like in the current releases.

> 
> http://www.connectivity.avocent.com/products/network-based/esp_16.asp
> 
> Thankfully the have a GPL driver but it was last updated against 2.6.23:
> 
> http://www.connectivity.avocent.com/drivers/esp_serial_hubs/dd64e069.asp
> 
> However I've never worked on any tty drivers so its a bit black magic  
> at this point.  I was hoping that an example would at least get me  
> able to bring the driver up to a point that we can get it into the  
> staging tree.

I would make it build, chuck it in the staging tree and go from there

isicom has a fairly good use of the newer helper functions we have so far
and struct tty_port so is probably as good an example as any if the
driver is using drivers/char. If its using the serial layer helpers then
apart from making sure you report the actual baud rate and termios
settings back little has changed (its all been hidden in the midlayer)
