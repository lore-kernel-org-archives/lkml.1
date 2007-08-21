Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbXHUOvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbXHUOvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 10:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbXHUOvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 10:51:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52903 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757241AbXHUOvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 10:51:42 -0400
Date: Tue, 21 Aug 2007 10:51:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jikos@jikos.cz>
cc: Florin Iucha <florin@iucha.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Greg KH <gregkh@suse.de>, <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <Pine.LNX.4.64.0708211402000.2460@twin.jikos.cz>
Message-ID: <Pine.LNX.4.44L0.0708211050570.4137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Jiri Kosina wrote:

> On Tue, 21 Aug 2007, Florin Iucha wrote:
> 
> > I have enabled USB debugging and I see a bunch (=46) of these messages:
> 
> >    [  $timestamp] usb 1-9: usb auto-suspend
> >    [  $timestamp] usb 1-9: usb auto-resume
> >    [  $timestamp] ehci_hcd 0000:00:02.1: GetStatus port 9 status 001005 POWER sig=se0 PE CONNECT
> >    [  $timestamp] usb 1-9: finish resume
> > The messages continued to be logged, even after the keyboard has
> > become unresponsive.
> 
> I guess that this is the card reader being suspended and resumed 
> afterwards. Do you by any chance see any improvement when you

FYI, the card reader suspend/resume problem should be fixed by this 
patch:

	http://marc.info/?l=linux-usb-devel&m=118764229910761&w=2

Alan Stern

