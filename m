Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbXKLNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbXKLNNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbXKLNNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:13:05 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:59569 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbXKLNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:13:04 -0500
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [2.6 patch] usb/serial/oti6858.c: cleanups
Date: Mon, 12 Nov 2007 14:14:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <20071105170757.GY12045@stusta.de> <200711052140.44505.oliver@neukum.org> <20071112103720.GG9771@stusta.de>
In-Reply-To: <20071112103720.GG9771@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121414.37322.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 12 November 2007 schrieb Adrian Bunk:
> On Mon, Nov 05, 2007 at 09:40:43PM +0100, Oliver Neukum wrote:
> > Am Montag 05 November 2007 schrieb Adrian Bunk:
> > > This patch containsthe following cleanups:
> > > - make the needlessly global send_data() static
> > > - an author without anemail address is OK, not a FIXME
> > 
> > That should be up to the author. If he thinks it should be there it might
> > be worth a FIXME
> 
> I would be very surprised if the reason for these FIXMEs was different 
> from the driver submitter not knowing a current address of the author...

Is there any evidence the author didn't submit it?

> > > - directly put the IDs into the id_table
> > 
> > Why?
> 
> I don't have a strong opinion on this one, but my impression was that 
> there's generally a move away from using once-used #define's for such 
> stuff.

Well, vendor IDs should be centralised.

> > > - remove the now-empty oti6858.h
> > > - kill the pointless driver version number
> > 
> > Why? There might be a new version in the future. If the author put
> > it there he might have had his reasons.
> 
> A version number makes sense when there's a maintainer who is 
> maintaining and using it to identify different versions of a driver.
> 
> But some ancient version number that contains less information than
> "the version of this driver shipped with kernel 2.6.xy" doesn't have any 
> value.

Very well.

	Regards
		Oliver
