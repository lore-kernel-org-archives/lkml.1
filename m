Return-Path: <linux-kernel-owner+w=401wt.eu-S932898AbXKOWFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbXKOWFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759600AbXKOWE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:04:59 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46188 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbXKOWE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:04:58 -0500
Date: Thu, 15 Nov 2007 23:04:45 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: 2.6.24-rc2-mm1
In-Reply-To: <20071115135332.5a007334.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711152302580.19853@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
 <20071114083906.178232cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141740110.15844@twin.jikos.cz>
 <Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz> <20071114181948.GA15240@kroah.com>
 <20071115192319.GA30186@kroah.com> <Pine.LNX.4.64.0711152238180.19853@twin.jikos.cz>
 <20071115135332.5a007334.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Andrew Morton wrote:

> > /dev/disk/by-id/scsi-SATA_HDS722516VLSA80_VN6D3ECDE5BD9D-part6: UNEXPECTED 
> > INCONSISTENCY; RUN fsck MANUALLY.
> >         (i.e., without -a or -p options)
> > Error writing block 1542 (Attempt to write block from filesystem resulted in short write).                                                                                         
> Yup.  Please apply the fix from
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/hot-fixes

Right, thanks.

OK, so I confirm that the fix from Dave fixes the lockup that I am 
obtaining with rc2-mm1 and also the warning from wrong kref reference 
count (lib/kref.c:33 kref_get()) is gone.

-- 
Jiri Kosina
