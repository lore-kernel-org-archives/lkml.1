Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYJCWqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYJCWqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYJCWqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:46:23 -0400
Received: from www.sr71.net ([198.145.64.142]:52769 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYJCWqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:46:22 -0400
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
From: Dave Hansen <dave@sr71.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0810040018200.4404@apollo>
References: <Pine.LNX.4.44L0.0810031608000.6462-100000@iolanthe.rowland.org>
	 <alpine.LFD.2.00.0810040018200.4404@apollo>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 15:46:15 -0700
Message-Id: <1223073975.7944.67.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-04 at 00:24 +0200, Thomas Gleixner wrote:
> On Fri, 3 Oct 2008, Alan Stern wrote:
> > On Fri, 3 Oct 2008, Dave Hansen wrote:
> > There are a number of other places in the trace where delays are
> > shorter than they should be.  This is out of my area of expertise, so 
> > I'm CC'ing Thomas Gleixner.  With luck he'll be able to help.
> > 
> > Thomas, the background for this problem is available here:
> > 
> > 	http://marc.info/?l=linux-kernel&m=122305738430115&w=2
> 
> Is NOHZ and HIGHRES disabled on those kernels? Hugh spotted a typo in
> that code today. Fix is below. It causes jiffies to increment too fast
> which explains your short delays.

Here's my config:

http://sr71.net/~dave/linux/config-10-03-2008.1.txt

No NOHZ or HIGHRES.  Is that what you meant?  

-- Dave

