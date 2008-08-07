Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYHGV0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYHGV0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbYHGV00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:26:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbYHGV0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:26:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG kmalloc-64: Object already free
Date: Thu, 7 Aug 2008 23:28:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Justin Mattock" <justinmattock@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Greg KH <greg@kroah.com>
References: <dd18b0c30808061421q20becfd3lad86158f05cea36f@mail.gmail.com> <20080807141953.5760f255.akpm@linux-foundation.org>
In-Reply-To: <20080807141953.5760f255.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072328.36162.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of August 2008, Andrew Morton wrote:
> On Wed, 6 Aug 2008 14:21:08 -0700
> "Justin Mattock" <justinmattock@gmail.com> wrote:
> 
> > I must be honest, 2.6.27-rc1-00156-g94ad374
> > has made me entirely lazy with wanting to add any patches
> > or taking anything out... but I guess I'll have to pull
> > and add a patch that was sent to me yesterday.
> > upon booting I saw this for the first time with isight: <dmesg below>
> > 
> 
> hrmpf.  Rafael went and assigned this to me.

In fact, you are automatically assigned every "memory management" bug.
