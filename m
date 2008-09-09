Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYIITve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYIITve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYIITvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:51:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:48442 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754955AbYIITvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:51:24 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19tT0J7Qjxt/3zpRezBN9CVwRw+vOhmeIP/Llf5CI
	KuqOfyMBNw/7GW
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Tue, 9 Sep 2008 21:51:12 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-3-git-send-email-jwilson@redhat.com> <20080909101422.329bd351@bike.lwn.net>
In-Reply-To: <20080909101422.329bd351@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809092151.18332.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Dienstag, 9. September 2008, Jonathan Corbet wrote:
> > +config LIRC_SERIAL
> > +	tristate "Homebrew Serial Port Receiver"
> > +	default n
> > +	depends on LIRC_DEV
> > +	help
> > +	  Driver for Homebrew Serial Port Receivers
> 
> What receivers might these be?  Do any actually exist?
[...]

This might actually be the most common setup, as it is very easy to 
build[1] with minimal soldering skills and has also been used by various 
vendors (older models of the TechniSat SkyStar2 DVB-S budget card, to name 
just one example; it is only slowly being replaced by alternative means, 
as serial ports are becoming rare on newer systems.

Regards
	Stefan Lippers-Hollmann

[1]	http://www.lirc.org/receivers.html
