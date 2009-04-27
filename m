Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbZD0V4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbZD0V4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbZD0Vym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:54:42 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45746 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757348AbZD0Vyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:54:41 -0400
Date: Mon, 27 Apr 2009 17:54:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: usbutils 0.81 release
In-Reply-To: <ac3eb2510904271407l7a480744s36d60025948aebd8@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0904271752090.18696-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Kay Sievers wrote:

> On Mon, Apr 27, 2009 at 22:48, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 27 Apr 2009, Greg KH wrote:
> >
> >> Kay Sievers (11):
> >>       rename configure.in -> configure.ac
> >>       delete spec file
> >
> > Why delete the spec file?  Don't you want to keep it for people who
> > would like to build an RPM?
> 
> Spec files are much too distro specific, they all contain custom
> distro variables, reference package names which are not the same
> across distros. They usually don't even agree on the directories the
> stuff is installed into. The usb.ids file as an example, is in a
> different location on every distro i have seen. :)
> 
> There is in most cases no point in keeping outdated spec files or
> debian directories in upstream source packages. The best when updating
> a package, is to start with the one that is in the source rpm of the
> distro one uses.

But what if the distro doesn't ship that package at all?  Then it's 
good to at least have a starting point that you can adapt to your own 
needs.  (Although I don't know of any major distributions that doesn't 
include usbutils...)

This isn't a big deal.  If you and Greg don't want to include a spec 
file then don't.

Alan Stern

