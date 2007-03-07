Return-Path: <linux-kernel-owner+w=401wt.eu-S965547AbXCGQgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965547AbXCGQgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965553AbXCGQgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:36:33 -0500
Received: from mail.emacinc.com ([63.245.244.68]:43944 "EHLO mail.emacinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965547AbXCGQgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:36:32 -0500
From: NZG <ngustavson@emacinc.com>
Organization: EMAC.Inc
To: Ben Nizette <ben.nizette@iinet.net.au>
Date: Wed, 7 Mar 2007 10:37:00 -0600
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200703061246.29615.ngustavson@emacinc.com> <45EE373B.80606@iinet.net.au>
In-Reply-To: <45EE373B.80606@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703071037.00322.ngustavson@emacinc.com>
X-SA-Exim-Connect-IP: 63.245.244.67
X-SA-Exim-Mail-From: ngustavson@emacinc.com
Subject: Re: passing function pointers through platform devices?
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Spam-Relay: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Once the generic GPIO framework migrates upstream from -mm
Thank you,  but I've reorganized my system to pass platform resources to a 
driver, which then registers simple gpio/pwm/quadencoder type devices as 
standard classes declared in a subdirectory.  Specific methods are then 
simple exported by stackable drivers.
It's unlikely I will adopt the GPIO interface at this point unless they really 
bring something new to the table.

I googled extensively and requested information on any current work here 
before I began this project and got zip. (see forwarded email paste)

I also emailed Robert Schwebel directly and he told me to ask VGER as it was 
being developed by someone else.

I don't mean to sound rude, but I really tried to build on existing work and 
it wasn't made available, so I've gone my own way, I had not other choice.

P.S. Forgive my VGER newbness, but what is "-mm" ?

thx,
NZG

> ----------  Forwarded Message  ----------
>
> Subject: GPIO device class driver
> Date: Tuesday 20 February 2007 10:40 am
> From: NZG <ngustavson@emacinc.com>
> To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
>
> I am currently developing support for an ep9xx based SBC and want to export
> it's GPIO through sysfs in a simple and standard way,
> without adding yet another platform specific gpio driver to the kernel.
>
> As I understand it, a gpio class has already been begun by Robert Schwebel
> in but has not as of yet become part of the mainstream kernel.
>
> Searching the archives for this yields no results since 2006.
>
> Can anyone point me to a current patch?
> I'd like to start from there.
>
> thank you,
> NZG
>
> -------------------------------------------------

