Return-Path: <linux-kernel-owner+w=401wt.eu-S1763697AbXHHWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763697AbXHHWWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbXHHWWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:22:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbXHHWWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:22:14 -0400
Date: Wed, 8 Aug 2007 18:22:06 -0400
From: Bill Nottingham <notting@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@insightbb.com>, Greg KH <greg@kroah.com>
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
Message-ID: <20070808222206.GA12375@nostromo.devel.redhat.com>
Mail-Followup-To: Kay Sievers <kay.sievers@vrfy.org>,
	Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Dmitry Torokhov <dtor@insightbb.com>, Greg KH <greg@kroah.com>
References: <46B8C8FA.9020100@redhat.com> <46B8D984.7040602@garzik.org> <46B8E773.5020406@redhat.com> <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com> <20070808193220.GB5001@nostromo.devel.redhat.com> <1186603327.3584.12.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186603327.3584.12.camel@lov.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers (kay.sievers@vrfy.org) said: 
> Ah, ok, makes sense. Yeah, that weird "platform devices loads itself by
> the name" thing got disabled in the platform subsystem. It caused
> modprobe loops for other devices.
> 
> The whole idea of issuing MODALIAS with plain module names instead of
> aliases can't really work, but the platform maintainer didn't like to
> use the usual aliases and the matches in the modules, for a reason I
> didn't understand while we talked about the problem last time.

So, the solution is for the platform device to issue a random modalias
that pcskpr exports?

Bill
