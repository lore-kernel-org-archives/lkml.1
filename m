Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZBJWBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZBJWBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbZBJWAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:00:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906AbZBJWAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:00:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
Date: Tue, 10 Feb 2009 23:00:18 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20090204191540.2d6abd87@infradead.org> <20090210202558.GH1382@ucw.cz>
In-Reply-To: <20090210202558.GH1382@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902102300.19065.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009, Pavel Machek wrote:
> On Wed 2009-02-04 19:15:40, Arjan van de Ven wrote:
> > Hi,
> > 
> > A MSI Wind (100) netbook landed on my desk with the comment "touchpad
> > doesn't work in Linux but works in XP". 
> > 
> > It turns out that there are a 2 separate issues with this netbook that
> > needed fixing 
> > 
> > 1) The touchpad requires the equivalent of "i8042.reset", which resets
> > the controller before probing. (This is done via a DMI quirk in patch
> > 2/2)
> > 
> > 2) About half the time, the reset will fail the first time. In the
> > current code, this is fatal and then also disables the keyboard in
> > addition to the touchpad. Ungood. Patch 1 makes the kernel retry the
> > reset upto five times before giving up (it seems the 2nd or 3rd time
> > succeed for me), and also adds an option to not make such a failure
> > fatal to the keyboard.
> > 
> > I don't think this is a regression, but it is pretty nasty behavior
> > (the machine is useless without) so it could be a 2.6.29 candidate...
> 
> Well, that beast was selling with linux preloaded, no? Or was it
> another msi wind? In such case I'd expect old kernel to work... or
> maybe some reasonable workaround somewhere...

In fact I have an MSI Wind and the touchpad is works on it just fine with the
current mainline.

Perhaps this one is just another MSI Wind.  What model is it?

Rafael
