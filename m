Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbXKLKhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbXKLKhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbXKLKho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:37:44 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58646 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756120AbXKLKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:37:43 -0500
Date: Mon, 12 Nov 2007 11:37:20 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] usb/serial/oti6858.c: cleanups
Message-ID: <20071112103720.GG9771@stusta.de>
References: <20071105170757.GY12045@stusta.de> <200711052140.44505.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711052140.44505.oliver@neukum.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 09:40:43PM +0100, Oliver Neukum wrote:
> Am Montag 05 November 2007 schrieb Adrian Bunk:
> > This patch containsthe following cleanups:
> > - make the needlessly global send_data() static
> > - an author without anemail address is OK, not a FIXME
> 
> That should be up to the author. If he thinks it should be there it might
> be worth a FIXME

I would be very surprised if the reason for these FIXMEs was different 
from the driver submitter not knowing a current address of the author...

> > - directly put the IDs into the id_table
> 
> Why?

I don't have a strong opinion on this one, but my impression was that 
there's generally a move away from using once-used #define's for such 
stuff.

> > - remove the now-empty oti6858.h
> > - kill the pointless driver version number
> 
> Why? There might be a new version in the future. If the author put
> it there he might have had his reasons.

A version number makes sense when there's a maintainer who is 
maintaining and using it to identify different versions of a driver.

But some ancient version number that contains less information than
"the version of this driver shipped with kernel 2.6.xy" doesn't have any 
value.

> 	Regards
> 		Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

