Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZBJXHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZBJXHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZBJXGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:06:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:38408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZBJXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:06:53 -0500
Date: Tue, 10 Feb 2009 15:06:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
Message-ID: <20090210150643.45278cf1@infradead.org>
In-Reply-To: <20090210202558.GH1382@ucw.cz>
References: <20090204191540.2d6abd87@infradead.org>
	<20090210202558.GH1382@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 21:25:58 +0100
Pavel Machek <pavel@suse.cz> wrote:

> On Wed 2009-02-04 19:15:40, Arjan van de Ven wrote:
> > Hi,
> > 
> > A MSI Wind (100) netbook landed on my desk with the comment
> > "touchpad doesn't work in Linux but works in XP". 
> > 
> > It turns out that there are a 2 separate issues with this netbook
> > that needed fixing 
> > 
> > 1) The touchpad requires the equivalent of "i8042.reset", which
> > resets the controller before probing. (This is done via a DMI quirk
> > in patch 2/2)
> > 
> > 2) About half the time, the reset will fail the first time. In the
> > current code, this is fatal and then also disables the keyboard in
> > addition to the touchpad. Ungood. Patch 1 makes the kernel retry the
> > reset upto five times before giving up (it seems the 2nd or 3rd time
> > succeed for me), and also adds an option to not make such a failure
> > fatal to the keyboard.
> > 
> > I don't think this is a regression, but it is pretty nasty behavior
> > (the machine is useless without) so it could be a 2.6.29
> > candidate...
> 
> Well, that beast was selling with linux preloaded, no? Or was it
> another msi wind? In such case I'd expect old kernel to work... or
> maybe some reasonable workaround somewhere...

afaik the newer ones have a different touchpad


> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
