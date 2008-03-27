Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYC0U4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYC0U4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759783AbYC0Uzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:55:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47187 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbYC0Uzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:55:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: what's the incompatibility between hibernation and =?iso-8859-1?q?hotplug=09memory?=
Date: Thu, 27 Mar 2008 21:55:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47EAD9A7.6020609@goop.org> <20080327084936.GD25876@elf.ucw.cz> <47EC0842.3020109@goop.org>
In-Reply-To: <47EC0842.3020109@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803272155.01463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, Jeremy Fitzhardinge wrote:
> Pavel Machek wrote:
> > Hi!
> >
> >   
> >>> I noticed that Kconfig warns that hibernation and hotplug memory are not 
> >>> compatible.  What's the issue?
> >>>       
> >> Generally, we might not be able to handle memory unplugged at a wrong time
> >> (eg. after we've created the image).
> >>
> >> Which part of Kconfig says that exactly?
> >>     
> >
> > Actually I believe it is simpler than that. We were not prepared to
> > deal with memory holes in hibernation code, so we just disabled it in
> > Kconfig...
> 
> Doesn't that mean its generally incompatible with non-flatmem memory 
> arrangements rather than hotplug memory specifically?

No, it should work with NUMA nowadays, actually.

Perhaps it's worth trying it with hotplug memory and see what problems arise?

Thanks,
Rafael
