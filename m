Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326Ab0ASSKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0ASSKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492Ab0ASSKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:10:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59402 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752187Ab0ASSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:10:00 -0500
Date: Tue, 19 Jan 2010 13:09:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Simmons <jsimmons@infradead.org>
cc: dri-devel@lists.sourceforge.net,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Font selection with i915
In-Reply-To: <alpine.LFD.2.00.1001191625420.29861@casper.infradead.org>
Message-ID: <Pine.LNX.4.44L0.1001191306180.1334-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, James Simmons wrote:

> 
> > When Fedora 12 loads i915 during initramfs probing on my system, the
> > driver automatically installs a tiny 160x64 font.  How can I prevent it
> > from doing this, or tell it to use a larger 80x25 font instead?
> > 
> > Is this documented anywhere?
> 
> Not really. Here is how you enable larger fonts. Configure your kernel. Go
> into the Graphics support menu. This the the menu that has the 
> DRI/Framebuffer and backlight options. You will see a "Console display 
> driver support" option. Select it and you will have a new menu. You will 
> see the option "Select compiled-in fonts". Enable that and select the font 
> you want. Most likely it will be the Sun 12x22 font. Build your kernel.
> 
> Their might be one more setup to do. Some distros like to load a console 
> font at boot up. Depending on the distro if that is the case you will have 
> to disable it.

It turns out that preventing the mode switch is easier.  Finding it
took a certain amount of digging, but the "nomodeset" kernel parameter
prevents the console from leaving normal VGA mode.  If only it were
documented...

Alan Stern

