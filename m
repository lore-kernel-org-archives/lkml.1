Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203Ab0ADH0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0ADH0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 02:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881Ab0ADH0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 02:26:23 -0500
Received: from daytona.panasas.com ([67.152.220.89]:49054 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752711Ab0ADH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 02:26:22 -0500
Message-ID: <4B41981A.6080204@panasas.com>
Date: Mon, 04 Jan 2010 09:26:18 +0200
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
References: <Pine.LNX.4.44L0.1001031149380.29885-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001031149380.29885-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jan 2010 07:26:21.0058 (UTC) FILETIME=[366C6620:01CA8D0F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2010 06:55 PM, Alan Stern wrote:
> On Sun, 3 Jan 2010, Boaz Harrosh wrote:
> 
>>> What patch of mine are you referring to?  So far James has rejected all
>>> the patches I have submitted recently.  I'm going to try again in the 
>>> near future...
>>>
>>
>> OK, that's my answer, I didn't know.
>>
>> Would you want that I attempt that collapsing of scsi_end_request() into scsi_io_completion
>> and the cleanup that implies? (that's the patch I meant.)
> 
> Okay, I don't mind if you would like to rewrite that patch.  The 
> version I wrote didn't just move code from one subroutine to another; 
> it also made a few semantic changes (the retry counter and the "error" 
> argument to blk_end_request()).  You'll probably want to break it 
> up into a few patches, where the first simply moves the code around and 
> the later ones do more significant things.
> 

Hi Alan, thanks

I'll only do the former and I'll let you continue with the later. .I.E the
code rearrangement and cleanup. Then perhaps it would be easier for you to
enhance the code with the retries and error returns. I do not have the setup
that can test / demonstrate those fixes, I'd rather you did them.

> As I recall, the most recent version of that patch is here:
> 
> 	http://marc.info/?l=linux-scsi&m=123991011815404&w=2
> 

Thanks

> Alan Stern
> 

Boaz
