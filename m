Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYJ2XhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYJ2XhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYJ2Xgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:36:53 -0400
Received: from kroah.org ([198.145.64.141]:43757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752617AbYJ2Xgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:36:52 -0400
Date: Wed, 29 Oct 2008 16:12:40 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jouni Malinen <jkmalinen@gmail.com>,
       Oliver Neukum <oliver@neukum.org>, Nicolas Bareil <nico@chdir.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] x86, gart: fix gart detection for Fam11h CPUs
Message-ID: <20081029231240.GA22325@kroah.com>
References: <e785a1360810280207p1c162decs5a70b8915ea08476@mail.gmail.com> <1225206834-6189-1-git-send-email-joerg.roedel@amd.com> <20081028165236.GA4503@kroah.com> <20081029095525.GA6345@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029095525.GA6345@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 10:55:25AM +0100, Joerg Roedel wrote:
> On Tue, Oct 28, 2008 at 09:52:36AM -0700, Greg KH wrote:
> > On Tue, Oct 28, 2008 at 04:13:54PM +0100, Joerg Roedel wrote:
> > > The AMD Fam11h CPUs have a K8 northbridge. This northbridge is different
> > > from other familys because it lacks GART support (as I just learned).
> > > But the kernel implicitly expects a GART if it finds an AMD northbridge.
> > > Fix this by removing the Fam11h northbridge id from the scan list of K8
> > > northbridges. This patch also changes the message in the GART driver
> > > about missing K8 northbridges to tell that the GART is missing which is
> > > the correct information in this case.
> > > 
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > Looks like this needs to be added to the 2.6.27-stable tree also, right?
> 
> No, this patch not. The PCI id was added during the .28 merge window.

Ah, you are right, sorry about that, was looking at the wrong tree here.

greg k-h
