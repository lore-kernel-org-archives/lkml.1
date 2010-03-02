Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0CBXzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:55:36 -0500
Received: from kroah.org ([198.145.64.141]:50201 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab0CBXzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:55:05 -0500
Date: Tue, 2 Mar 2010 15:53:53 -0800
From: Greg KH <greg@kroah.com>
To: Peter Feuerer <peter@piie.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] usb-serial / pl2302 corrupted receive
Message-ID: <20100302235353.GB2196@kroah.com>
References: <cone.1267466820.296261.3385.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1267466820.296261.3385.1000@deskpiie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 07:07:00PM +0100, Peter Feuerer wrote:
> Hi Greg,
> 
> I tried to flash an AVR microcontroler via an USB to serial
> converter which uses pl2302 driver. It didn't work, so I set up
> following test to reproduce the bug:
> 
> I connected two pls2302 usb-serial converters to two different
> usb-ports of my machine and connected them with a rs232-nullmodem
> cable to each other.
> 
> Terminal1:
> cat /dev/ttyUSB1
> 
> Terminal2:
> while true; do echo 123456789012345678901234567890 > /dev/ttyUSB0 ; done

cat and echo are known to not work well with usb to serial devices.  Can
you duplicate this with a "real" tty program like minicom or something
else?

thanks,

greg k-h
