Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXDTX3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXDTX3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDTX3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:29:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35008 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXDTX3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:29:33 -0400
Date: Fri, 20 Apr 2007 16:25:22 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420232522.GA10949@kroah.com>
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <462906E5.8060609@goth.net> <20070420184956.GD13939@redhat.com> <462920EE.2020202@goth.net> <20070420203342.GA622@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420203342.GA622@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 04:33:42PM -0400, Dave Jones wrote:
> On Fri, Apr 20, 2007 at 04:22:06PM -0400, Preston A. Elder wrote:
>  > Dave, Greg,
>  > 
>  > Here is the trace with 2.6.20.6
>  > 
>  > I added back in my trace code, as you see.  As you can also see,
>  > agp_amdk7_probe is still not called.
> 
> Try looking down in __driver_attach()
> The fact that we're not calling the ->probe function is quite bizarre.
> 
> It could be this in __driver_attach
> 
>         if (!dev->driver)
>                 driver_probe_device(drv, dev);
> 
> Though that'd be odd.
> 
> Putting a #define DEBUG 1 in drivers/base/dd.c may also yield some clues.

Setting CONFIG_DEBUG_DRIVER automatically enables this also and might
provide some more hints.

thanks,

greg k-h
