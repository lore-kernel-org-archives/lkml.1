Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbZJJCDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbZJJCDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 22:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934432AbZJJCDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 22:03:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36285 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761174AbZJJCDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 22:03:39 -0400
Date: Fri, 9 Oct 2009 22:03:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 (and 2.6.32-rc3)
In-Reply-To: <Pine.LNX.4.44L0.0910092153300.25597-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0910092201470.25597-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Alan Stern wrote:

> On Sat, 10 Oct 2009, Benjamin Herrenschmidt wrote:
> 
> > (Adding Rafael)
> > 
> > On Sat, 2009-10-10 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> > > On Sat, 2009-10-10 at 11:25 +1100, Benjamin Herrenschmidt wrote:
> > > > Hi folks !
> > > > 
> > > > My USB GSM modem (Huawei 169, pretty common stuff) stopped working in
> > > > the latest ubuntu karmic update. So far, I tracked it down to a
> > > > regression that happened in the stable releases between 2.6.31.1 and
> > > > 2.6.31.2 (still present in .3). I haven't tested 2.6.32-rc* yet and
> > > > haven't had a chance to bisect (need to make myself a trimmed
> > > > down .config first).

> This looks a lot like a hardware problem, such as bad USB cables.  
> Could you collect a usbmon trace for bus 4?  It ought to show whether
> this is the case or whether software is at fault.

If it's not a hardware issue and the modem really does work okay in 
2.6.31.1, you should also collect a usbmon trace under that kernel for 
comparison.

Alan Stern

