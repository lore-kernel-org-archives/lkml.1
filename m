Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbXKLNcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbXKLNcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbXKLNcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:32:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33683 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758518AbXKLNcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:32:05 -0500
Date: Mon, 12 Nov 2007 14:31:41 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [2.6 patch] usb/serial/oti6858.c: cleanups
Message-ID: <20071112133141.GI9771@stusta.de>
References: <20071105170757.GY12045@stusta.de> <200711052140.44505.oliver@neukum.org> <20071112103720.GG9771@stusta.de> <200711121414.37322.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711121414.37322.oliver@neukum.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 02:14:36PM +0100, Oliver Neukum wrote:
> Am Montag 12 November 2007 schrieb Adrian Bunk:
> > On Mon, Nov 05, 2007 at 09:40:43PM +0100, Oliver Neukum wrote:
> > > Am Montag 05 November 2007 schrieb Adrian Bunk:
> > > > This patch containsthe following cleanups:
> > > > - make the needlessly global send_data() static
> > > > - an author without anemail address is OK, not a FIXME
> > > 
> > > That should be up to the author. If he thinks it should be there it might
> > > be worth a FIXME
> > 
> > I would be very surprised if the reason for these FIXMEs was different 
> > from the driver submitter not knowing a current address of the author...
> 
> Is there any evidence the author didn't submit it?

Look at commit 49cdee0ed0fce9e1bda81f5dcad8d5cce6aec983.

> > > > - directly put the IDs into the id_table
> > > 
> > > Why?
> > 
> > I don't have a strong opinion on this one, but my impression was that 
> > there's generally a move away from using once-used #define's for such 
> > stuff.
> 
> Well, vendor IDs should be centralised.
>...

It was #define OTI6858_VENDOR_ID      0x0ea0

And the only other usages of this vendor ID are in 
drivers/usb/storage/unusual_devs.h where vendor ID
defines do not seem to be used at all...

> 	Regards
> 		Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

