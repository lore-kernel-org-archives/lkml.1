Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595Ab0ACKLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab0ACKLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 05:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340Ab0ACKLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 05:11:51 -0500
Received: from daytona.panasas.com ([67.152.220.89]:37027 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205Ab0ACKLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 05:11:51 -0500
Message-ID: <4B406D62.8060500@panasas.com>
Date: Sun, 03 Jan 2010 12:11:46 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: James Bottomley <James.Bottomley@suse.de>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>,
       Stable Tree <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH] scsi_lib: Bug in completion of bidi commands
References: <Pine.LNX.4.44L0.0912312144080.16709-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912312144080.16709-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jan 2010 10:11:49.0634 (UTC) FILETIME=[29E71E20:01CA8C5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2010 04:46 AM, Alan Stern wrote:
> On Thu, 31 Dec 2009, Boaz Harrosh wrote:
> 
>> James hi.
>>
>> What about this BUG. It affects anybody doing bidi commands. The possibilities
>> are an sglist leak at best, and a crash at worse.
>>
>> I understand this code needs cleanup, but first things first. Lets first fix the
>> bug, which should also go to stable. Then the cleanup can go to next merge window.
>>
>> BTW: Should I attempt a cleanup on current code, or should I wait for Alan's Patch
>> to go in first?
> 
> What patch of mine are you referring to?  So far James has rejected all
> the patches I have submitted recently.  I'm going to try again in the 
> near future...
> 

OK, that's my answer, I didn't know.

Would you want that I attempt that collapsing of scsi_end_request() into scsi_io_completion
and the cleanup that implies? (that's the patch I meant.)

> Alan Stern
> 

Thanks && Happy new decade
Boaz
