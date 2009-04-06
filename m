Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZDFRMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZDFRMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZDFRLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:11:48 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:13613 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751989AbZDFRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:11:47 -0400
Message-ID: <49DA37C4.4090208@panasas.com>
Date: Mon, 06 Apr 2009 20:11:32 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] final set of SCSI updates for the merge window
References: <1239033266.3641.9.camel@mulgrave>
In-Reply-To: <1239033266.3641.9.camel@mulgrave>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2009 17:11:42.0719 (UTC) FILETIME=[C1CAD0F0:01C9B6DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2009 06:54 PM, James Bottomley wrote:
> This is just an assorted set of driver updates (fcoe, qla2x, stex etc.)
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> The short changelog is:
> 
> 
<snip>
> Hannes Reinecke (1):
>       aic7xxx: leaves timer running on init failure
> 

I was hoping you would also include this patch:

http://www.spinics.net/lists/linux-scsi/msg34174.html
Tested-by: Boaz Harrosh <bharrosh@panasas.com>

After Hannes explained it looks totally un-dangerous, I've
been running with it ever since.

It does remove that annoying dmsg warning every scsi ULD
has.

<snip>

Thanks
Boaz
