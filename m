Return-Path: <linux-kernel-owner+w=401wt.eu-S1765647AbYA2U1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765647AbYA2U1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYA2U1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:27:39 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25733 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778AbYA2U1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:27:38 -0500
Message-ID: <479F8C08.2060207@panasas.com>
Date: Tue, 29 Jan 2008 22:26:48 +0200
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
References: <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk> <479F856C.4090900@panasas.com> <479F880F.20709@panasas.com> <20080129201328.GZ15220@kernel.dk>
In-Reply-To: <20080129201328.GZ15220@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2008 20:26:52.0858 (UTC) FILETIME=[48B679A0:01C862B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008 at 22:13 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>> Ok this is not in Linus tree is it? Hence I did not have that failure.
>>>
>>> Boaz
>>>
>>>
>> actually James bidi tree has a fix for this in the scsi_data_buffer patch.
>>
>> what you sent is not enough there are other places. look at this patch I
>> sent to the list.
>>
>> http://www.spinics.net/lists/linux-scsi/msg21938.html
> 
> Hard to compare, since its on different bases.
Yes in this patchset I have taken your sg branch at the time, and
rebased it ontop of scsi_data_buffer patch. Because I felt that
it is more natural for this patch to come after the scsi total
cleanup that is scsi_data_buffer. Then the extraction to sg_table
is simple and trivial.

What I meant to point out with this patch is that all the exact same
places that are touched there should be fixed when moving to sg_table.

Look at it. It is a revised version of your patch.

> 
>> Could we take the 2 SG patches and submit them through the scsi
>> bidi tree? It is much more natural to have them in one tree as one
>> patchset then try coordinate with git-merge. Actually if you look at it,
>> the biggest change is to SCSI. So I think it is more natural this way
> 
> What 2 sg patches do you mean?
> 

I mean the patches that where in sg branch of the linux-block tree, But
I see that it is now to late, and that they are in Linus already

James the most simple is to submit the scsi_data_buff patch that fixes
all these places. If not do you want that I send in fixes?

Boaz
