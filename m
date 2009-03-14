Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZCNTez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZCNTez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 15:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZCNTeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 15:34:46 -0400
Received: from kotten8a.marieberg.ac ([213.238.238.22]:40484 "HELO
	iluvatar.nyren.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753804AbZCNTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 15:34:45 -0400
Date: Sat, 14 Mar 2009 20:34:40 +0100 (CET)
From: Ralf Nyren <ralf@nyren.net>
X-X-Sender: plumbum@fujje.iml.umu.se
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, klloyd@sierrawireless.com,
       rfiler@sierrawireless.com
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
In-Reply-To: <20090314040322.GB3417@kroah.com>
Message-ID: <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se> <20090314040322.GB3417@kroah.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I choose to only test download speeds for now but upload will also be of
interest later on.

I had actually tried to change the N_IN_URB/N_OUT_URB before sending of the
report but now I've been testing with both 8 and 128 but the speed remains the
same. Download speed max 1.0Mbit/s in Linux while the Windows driver could get
an average of 2.5Mbit/s at my current location (different location than during
the last test).

I have also tried the new 1.6.0 driver as kindly supplied by Sierra but the
speed remained the same 1.0Mbit/s with the new driver as well...

Anything else you think I could try?

Best regards, Ralf


On Fri, 13 Mar 2009, Greg KH wrote:

>
> Are you testing up or down speeds?
>
> If you want to, and you think the driver is the problem, try changing
> the values in drivers/usb/serial/sierra.c:
> 	/* per port private data */
> 	#define N_IN_URB        4
> 	#define N_OUT_URB       4
> 	#define IN_BUFLEN       4096
>
> Try bumping up the N_IN_URB and N_OUT_URB values a bunch and let me know
> if things go faster now.
>
> thanks,
>
> greg k-h
>
