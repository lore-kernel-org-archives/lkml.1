Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbZGQAXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbZGQAXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933734AbZGQAXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:23:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:35136 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933696AbZGQAXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:23:31 -0400
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <greg@kroah.com>, Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714161514.GA2026@kroah.com>
	 <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 10:23:09 +1000
Message-Id: <1247790189.27937.74.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 13:54 +1000, Dave Airlie wrote:
> On Wed, Jul 15, 2009 at 2:15 AM, Greg KH<greg@kroah.com> wrote:
> > Minor comment:
> >
> >> +#ifdef DEBUG
> >> +     printk(KERN_DEBUG "%s\n", __func__);
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

Then use pr_debug :-)

Ben.


