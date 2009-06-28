Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZF1QAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZF1QAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZF1QAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:00:41 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:6849
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753702AbZF1QAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:00:41 -0400
Message-ID: <4A4793A6.8080802@panasas.com>
Date: Sun, 28 Jun 2009 19:00:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: James Smart <James.Smart@Emulex.Com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Olaf Hering <olh@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Benny Halevy <bhalevy@panasas.com>,
       LKML <linux-kernel@vger.kernel.org>,
       scst-devel <scst-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
 and scsi_device_type
References: <1246122359.32198.7.camel@hpdv5.satnam> <4A47222B.5020702@panasas.com> <4A477F00.70305@emulex.com>
In-Reply-To: <4A477F00.70305@emulex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2009 16:00:42.0001 (UTC) FILETIME=[967E1810:01C9F809]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2009 05:32 PM, James Smart wrote:
> Sorry folks --  the nuance of the clibrary having it's own version of a 
> kernel header for distros was completely unknown to me.
> 
> Christoph mentioned this to me last week, with the recommendation to 
> back out the patch and move the other headers that were exprted into 
> include/linux - thus nothing in include/scsi gets export.  No Problem. 
> and I'll do so shortly.
> 
> How does a lowly contributor track these kind of nuances ?
> 
> -- james s
> 

Don't give up so fast. Please. 
Kernel should reclaim back control of it's own headers.
/usr/include/scsi is Kernel territory from the start.
This is just a plain historical mistake that glibc had
to duplicate all these Kernel headers.

Please lets start with scsi.h and then advance slowly
to more Headers like sg.h

Andrew, please help.

Thanks
Boaz
