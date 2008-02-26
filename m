Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYBZFU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYBZFU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYBZFUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:20:21 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:36074 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751136AbYBZFUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:20:19 -0500
Date: Tue, 26 Feb 2008 14:20:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] maple: fix device detection
Message-ID: <20080226052009.GA19814@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1203863423.6474.27.camel@localhost.localdomain> <1203889834.6474.35.camel@localhost.localdomain> <1203892373.6299.2.camel@localhost.localdomain> <20080225053313.GA27064@renesas.com> <1203925226.6364.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203925226.6364.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 07:40:26AM +0000, Adrian McMenamin wrote:
> On Mon, 2008-02-25 at 14:33 +0900, Paul Mundt wrote:
> > On Sun, Feb 24, 2008 at 10:32:53PM +0000, Adrian McMenamin wrote:
> > > On Sun, 2008-02-24 at 21:50 +0000, Adrian McMenamin wrote:
> > > > On Sun, 2008-02-24 at 14:30 +0000, Adrian McMenamin wrote:
> > > > > The maple bus driver that went into the kernel mainline in
> > > > > September 2007 contained some bugs which were revealed by the
> > > > > update of the kobj code for the current release series.
> > > > > Unfortunately those bugs also helped ensure maple devices were
> > > > > properly detected. This patch (against the current git) now ensures
> > > > > that devices are properly detected again.
> > > > > 
> > > > 
> > > > Further testing has shown this has introduced another bug, this time
> > > > limiting the effectiveness of subdevice detection. Please ignore this
> > > > while I work on a fix.
> > > > 
> > > Sorry for the confusion, in fact there is nothing wrong with this code
> > > (ie it should be applied), the error was in the driver for the Dreamcast
> > > controller (the device, in general, into which the subdevices are
> > > plugged in and out).
> > > 
> > > I will post a fix for that.
> > > 
> > > Sorry again.
> > > 
> > So what exactly is supposed to be applied here?
> 
> The patch at the start of this thread - ie
> http://lkml.org/lkml/2008/2/24/125  - this should really go in now as it
> fixes a problem with current code.
> 
Ok, that's applied. Note that the original body was horribly word
wrapped, and your patch was not in -p1 format (while others in the series
are, for reasons that aren't entirely obvious).

> In addition there are two patch sets to add new device support:
> 
> http://lkml.org/lkml/2008/2/24/211    - maple controller
> 
> http://lkml.org/lkml/2008/2/24/121  (thread) - maple mouse
> 
This is not 2.6.25 material. Once you have Acked-by's from the input
folks, I'll queue these up in my 2.6.26 tree. The bus unplug thing is
rather unusual, I don't know if Greg has any comments on that or not.
