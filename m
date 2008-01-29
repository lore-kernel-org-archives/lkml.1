Return-Path: <linux-kernel-owner+w=401wt.eu-S1765908AbYA2ULe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765908AbYA2ULe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYA2ULX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:11:23 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:40341 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYA2ULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:11:22 -0500
Message-ID: <479F880F.20709@panasas.com>
Date: Tue, 29 Jan 2008 22:09:51 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk> <479F856C.4090900@panasas.com>
In-Reply-To: <479F856C.4090900@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
> Ok this is not in Linus tree is it? Hence I did not have that failure.
> 
> Boaz
> 
> 

actually James bidi tree has a fix for this in the scsi_data_buffer patch.

what you sent is not enough there are other places. look at this patch I
sent to the list.

http://www.spinics.net/lists/linux-scsi/msg21938.html

Could we take the 2 SG patches and submit them through the scsi
bidi tree? It is much more natural to have them in one tree as one
patchset then try coordinate with git-merge. Actually if you look at it,
the biggest change is to SCSI. So I think it is more natural this way

Boaz
