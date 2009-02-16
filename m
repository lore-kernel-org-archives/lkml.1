Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZBPWNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZBPWNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZBPWNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:13:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57637 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZBPWNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:13:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFD] Automatic suspend
Date: Mon, 16 Feb 2009 23:12:48 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <200902162248.34287.rjw@sisk.pl> <20090216135339.53b4a911@infradead.org>
In-Reply-To: <20090216135339.53b4a911@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162312.50556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Arjan van de Ven wrote:
> On Mon, 16 Feb 2009 22:48:32 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > Userland should never ever control the state of a device like this
> > > directly. It should do so by a) closing the device and b) setting
> > > latency / functional requirements.
> > 
> > The user, however, may want to forcibly put a device into a low power
> > state without stopping all of the applications that depend on it (eg.
> > have it open). Do you think that we shouldn't allow users to do such
> > things?
> 
> I would think that that is a bad mistake to do. It basically breaks the 
> contract that the kernel has with userspace.... 

OK, so I think there are two things that user space may be allowed to do as
far as putting devices into low power states is concerned:
* disable/enable the automatic power management of the device (provided that
  the driver supports the automatic PM)
* check what power states devices are in.

Thanks,
Rafael
