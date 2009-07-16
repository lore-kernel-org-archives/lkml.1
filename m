Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZGPEDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZGPEDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZGPEDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:03:12 -0400
Received: from kroah.org ([198.145.64.141]:59061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZGPEDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:03:12 -0400
Date: Wed, 15 Jul 2009 21:02:25 -0700
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
Message-ID: <20090716040225.GA31064@kroah.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
 <20090714161514.GA2026@kroah.com>
 <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 01:54:42PM +1000, Dave Airlie wrote:
> On Wed, Jul 15, 2009 at 2:15 AM, Greg KH<greg@kroah.com> wrote:
> > Minor comment:
> >
> >> +#ifdef DEBUG
> >> +     printk(KERN_DEBUG "%s\n", __func__);
> >> +#endif
> >
> > You should just use 'dev_dbg() for any debugging statments like this.
> > You can turn them on and off dynamically, and you get all of the proper
> > device information as to what is going on automatically.
> >
> > Plus, there's no need for a #ifdef in the code, which is generally
> > frowned apon in .c files.
> >
> 
> We don't have a device in this case, vga arb is more of an abstraction than
> an actual device.
> 
> I suppose if we were feeling crazy we could add a platform device for it.

No, then use the debug_printk() functions, so that you tie into the
kernel-wide debug message system.  Please don't roll your own anymore,
there is no need to.

thanks,

greg k-h
