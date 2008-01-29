Return-Path: <linux-kernel-owner+w=401wt.eu-S1765129AbYA2UYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765129AbYA2UYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYA2UY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:24:28 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53351 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYA2UY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:24:26 -0500
Subject: Re: [BUG] 2.6.24-git usb reset problems
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20080129200651.GW15220@kernel.dk>
References: <200801291531.39825.oliver@neukum.org>
	 <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>
	 <20080129191024.GO14375@one-eyed-alien.net>
	 <1201635195.3069.36.camel@localhost.localdomain>
	 <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk>
	 <479F856C.4090900@panasas.com> <20080129200311.GV15220@kernel.dk>
	 <1201637090.3069.38.camel@localhost.localdomain>
	 <20080129200651.GW15220@kernel.dk>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 15:24:17 -0500
Message-Id: <1201638257.3069.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 21:06 +0100, Jens Axboe wrote:
> > I will ... but it will cause an explosion in the bidirectional tree
> > again.  I think the bidi updates also fix this.  However, give me time
> > to rebase and verify.
> 
> OK thanks, just wanted to make sure that we didn't both expect each
> other to handle it :-)

Yes, confirm that; I think this is already fixed in scsi-misc-2.6.
Could you pull from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

and verify with your device?

Thanks,

James


