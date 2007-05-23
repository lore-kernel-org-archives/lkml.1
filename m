Return-Path: <linux-kernel-owner+w=401wt.eu-S1763315AbXEWAt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315AbXEWAt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbXEWAtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:49:22 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:26402 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985AbXEWAtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A1PwwAA8RFb2Skuqh0IDwmXvjFqi/VKNw3vcQLTfh7rQWiSB9giQSA3HK49s/m8bi8PmB0WxYVcvUCqeHd4Iv/wYn9n8R4iyBN89fm6/HU6n5sAck+HoV1G4QMeOg4PNgVvvmkVTz1psx1QXY8XZUCTC4WzVSxcbIvsiQQdzM6A=
Subject: Re: [PATCH 1/2] allow console unregistration
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>
In-Reply-To: <200705221443.04859.jbarnes@virtuousgeek.org>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705171532.28799.jesse.barnes@intel.com>
	 <1179444190.5092.4.camel@daplas>
	 <200705221443.04859.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 08:49:14 +0800
Message-Id: <1179881354.4638.15.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 14:43 -0700, Jesse Barnes wrote:
> On Thursday, May 17, 2007, Antonino A. Daplas wrote:
> > On Thu, 2007-05-17 at 15:32 -0700, Jesse Barnes wrote:
> > > Randy just informed me that the patch limits are bigger now, so here
> > > are the actual patches.
> > >
> > > This patch allows for proper console unregistration via the VT layer,
> > > and updates the FB layer to use it.  This makes debugging new console
> > > drivers much easier, since you can properly clean them up before
> > > unloading. Antonio already checked it out (and suggested a tweak for
> > > the fbcon side) so I think it's on its way already via the FB tree.
> >
> > Sorry, I was busy and got sidetracked so I wasn't able to work on this
> > for 2 weeks.  Yes, this should work for now, at least for debugging
> > purposes. I'll work on refining on fbcon side, hopefully for
> > 2.6.22-2.6.23 time frame.
> 
> Btw, here's an updated console unregister patchset with signoff in the
> off chance you like it right away. :)
> 
> When rmmod'd, some drivers might like to unregister the console they have
> registered (e.g. the fbcon driver), so export unbind_con_driver.  It
> properly cleans up console references and takes care of switching to
> one of the other registered drivers as needed.
> 

I'm working on something that will need these functions
(unbind/bind_con_driver) to be exposed, so I'm fine with this.

Tony


