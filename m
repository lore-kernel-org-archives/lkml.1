Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbXC0FPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbXC0FPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXC0FPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:15:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60897 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933886AbXC0FPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:15:40 -0400
Message-ID: <4608A876.8090104@garzik.org>
Date: Tue, 27 Mar 2007 01:15:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Andreas Schwab <schwab@suse.de>
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata-vsc broken on SGI Prism
References: <je8xdnova3.fsf@sykes.suse.de> <20070325012044.97dc14fc.akpm@linux-foundation.org>
In-Reply-To: <20070325012044.97dc14fc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 24 Mar 2007 10:17:24 +0100 Andreas Schwab <schwab@suse.de> wrote:
>> commit 7cbaa86b937b0b1fab95c159989f6a3c00bbcf78
>> Author: Dan Wolstenholme <daniel@wolstenholme.net>
>> Date:   Tue Jan 9 05:59:21 2007 -0500
>>
>>     [libata] sata_vsc: support PCI MSI
>>     
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>
> 
> It seems that little of that patch remains present in current mainline.


An unfortunately illusion of further changes.  The "turn MSI on" stuff 
is still here, but Tejun's cleanups made some of that housekeeping code 
go away.

But, as Andreas was guessing, the problem here is the platform's MSI 
support, with this as an unfortunate symptom.

	Jeff


