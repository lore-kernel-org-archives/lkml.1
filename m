Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZFYRrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZFYRrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZFYRrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:47:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbZFYRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:47:05 -0400
Date: Thu, 25 Jun 2009 10:46:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out 
 of the 'queue' sysfs directory.
In-Reply-To: <yq1k530qkm7.fsf@sermon.lab.mkp.net>
Message-ID: <alpine.LFD.2.01.0906251045450.3605@localhost.localdomain>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <yq1k530qkm7.fsf@sermon.lab.mkp.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, Martin K. Petersen wrote:
> 
> Neil> So I asked git why it as added, and it pointed to
> Neil>   commit 1308835ffffe6d61ad1f48c5c381c9cc47f683ec
> 
> Neil> which suggests that it was added so that user space could tell the
> Neil> kernel whether the device was rotational, rather than the other
> Neil> way around.
> 
> There's an option to do it via udev for broken devices that don't report
> it.  But both SCSI and ATA have a setting that gets queried and the
> queue flag set accordingly.

.. except few devices actually set it. 

That flag is _definitely_ all about the user being able to override it.

		Linus
