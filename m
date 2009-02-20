Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZBTKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZBTKrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZBTKrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:47:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54021 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZBTKrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:47:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 20 Feb 2009 11:46:55 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org> <200902192321.47891.rjw@sisk.pl> <200902192358.13068.oliver@neukum.org>
In-Reply-To: <200902192358.13068.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201146.59944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009, Oliver Neukum wrote:
> Am Donnerstag 19 Februar 2009 23:21:46 schrieb Rafael J. Wysocki:
> > > That's the whole point behind userspace wakelocks!  They provide a
> > > mechanism for userspace to tell the kernel when (as far as userspace 
> is
> > > concerned) it is or is not okay to auto-sleep.
> >
> > Still, one can go further and observe that the user space can in fact start
> > automatic suspend by itself whenever it knows it's appropriate ...
> 
> User space initiating this is a race condition.

Do you mean a race with the other user space processes or with the kernel?

Rafael
