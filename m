Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZAOV0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZAOV0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZAOV0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:26:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35730 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754395AbZAOV0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:26:24 -0500
Date: Thu, 15 Jan 2009 16:26:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [patch 00/94] 2.6.28.1 stable review
In-Reply-To: <20090115211234.GA28143@suse.de>
Message-ID: <Pine.LNX.4.44L0.0901151623180.2181-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Greg KH wrote:

> On Thu, Jan 15, 2009 at 09:59:59PM +0100, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On thursday january 15th, 2009 Greg KH wrote:
> > > This is the start of the stable review cycle for the 2.6.28.1 release.
> > > There are 94 patches in this series, all will be posted as a response to
> > > this one.  If anyone has any issues with these being applied, please let
> > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Please consider adding the following patch, referring to
> > http://bugzilla.kernel.org/show_bug.cgi?id=12301
> > 
> > commit 2caf7fcdb8532045680f06b67b9e63f0c9613aaa
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Wed Dec 31 11:31:33 2008 -0500
> 
> <snip>
> 
> Alan said he would provide a backported version of this patch for .28
> after it went into Linus's tree, as this version will not apply
> properly.
> 
> Alan, care to come up with something?

Apart from the formatting options used with "diff", my backported 
version is identical with the one Stefan posted.  However there remains 
the question of how to handle the additional changes needed for the 
disable_endpoint pathways.

Maybe it would be best to submit this patch for 2.6.28.stable now and 
submit the second patch after it gets into the mainline.

Alan Stern

