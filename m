Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbZJEMnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbZJEMnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZJEMnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:43:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZJEMnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:43:39 -0400
Message-ID: <4AC9E9D5.6080809@suse.de>
Date: Mon, 05 Oct 2009 14:43:01 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       James.Bottomley@HansenPartnership.com, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Add hpsa driver for HP Smart Array controllers.
References: <20091001211705.15591.76403.stgit@beardog.cce.hp.com> <20091001143035.a83a7564.akpm@linux-foundation.org> <20091001214239.GA15691@beardog.cce.hp.com>
In-Reply-To: <20091001214239.GA15691@beardog.cce.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Miller wrote:
> On Thu, Oct 01, 2009 at 02:30:35PM -0700, Andrew Morton wrote:
>> On Thu, 01 Oct 2009 16:25:30 -0500
>> "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
>>
>>> Add hpsa driver for HP Smart Array controllers.
>>>
>>> This driver supports a subset of HP Smart Array Controllers.
>>> It is a SCSI alternative to the cciss driver.
>> Does it support all the devices which cciss supports?
>>
>> IOW, do we have a plan here to remove the cciss driver or must we
>> maintain both drivers indefinitely?
> 
> Andrew,
> The hpsa driver supports only the latest generation of Smart Array
> controllers plus the P400 and P800. The goal was to have minimal overlap but
> if we included only the very latest I suspect little testing would be done
> because of the availability of new hardware.
> 
> No new controllers will be added to cciss once hpsa is accepted. We're
> looking at supporting both drivers for 3 or 4 years until cciss can be
> phased out completely.
> 
Yeah!

Thanks, Mike and Stephen, for the effort you put into this.
Very much appreciated.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
