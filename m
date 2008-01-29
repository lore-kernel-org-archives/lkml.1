Return-Path: <linux-kernel-owner+w=401wt.eu-S934143AbYA2UNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143AbYA2UNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbYA2UNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:13:35 -0500
Received: from brick.kernel.dk ([87.55.233.238]:7737 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbYA2UNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:13:33 -0500
Date: Tue, 29 Jan 2008 21:13:29 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080129201328.GZ15220@kernel.dk>
References: <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk> <479F856C.4090900@panasas.com> <479F880F.20709@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F880F.20709@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Boaz Harrosh wrote:
> >>
> > Ok this is not in Linus tree is it? Hence I did not have that failure.
> > 
> > Boaz
> > 
> > 
> 
> actually James bidi tree has a fix for this in the scsi_data_buffer patch.
> 
> what you sent is not enough there are other places. look at this patch I
> sent to the list.
> 
> http://www.spinics.net/lists/linux-scsi/msg21938.html

Hard to compare, since its on different bases.

> Could we take the 2 SG patches and submit them through the scsi
> bidi tree? It is much more natural to have them in one tree as one
> patchset then try coordinate with git-merge. Actually if you look at it,
> the biggest change is to SCSI. So I think it is more natural this way

What 2 sg patches do you mean?

-- 
Jens Axboe

