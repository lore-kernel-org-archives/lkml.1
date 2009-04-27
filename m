Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZD0VVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZD0VVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZD0VVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:21:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38133 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754914AbZD0VVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:21:45 -0400
Date: Mon, 27 Apr 2009 17:21:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: usbutils 0.81 release
In-Reply-To: <20090427210059.GA12446@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0904271715470.17474-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Greg KH wrote:

> On Mon, Apr 27, 2009 at 04:48:00PM -0400, Alan Stern wrote:
> > On Mon, 27 Apr 2009, Greg KH wrote:
> > 
> > > Kay Sievers (11):
> > >       rename configure.in -> configure.ac
> > >       delete spec file
> > 
> > Why delete the spec file?  Don't you want to keep it for people who 
> > would like to build an RPM?
> 
> Do people build rpms out of tarballs that aren't coming from their
> distro anymore?

Sure they do.  If you've got an RPM-based system, and you want to
install a package version that's more recent than the one bundled in
your distribution (or if your distribution doesn't include the package
at all), then you'd want to build your own RPM.

>  I didn't realise this, and can put it back, but it's
> one more thing to forget to bump the version number on :(

It's not urgent.  You're going to be making other changes too...  new 
output formats and replacing libusb, right?  So include the spec file 
again when you do the next release.

(BTW, the spec file probably wants a little updating anyhow to match 
the changes you and Kay have been doing.  Not to mention that older 
versions of RPM used a different specification for the kind of 
licensing -- IIRC, the old RPM used a "copyright" tag whereas the 
current RPM uses a "license" tag.)

Alan Stern

