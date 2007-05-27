Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbXE0Ppt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbXE0Ppt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbXE0Ppl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:45:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40249 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbXE0Ppk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:45:40 -0400
Message-ID: <4659A7A1.2070100@garzik.org>
Date: Sun, 27 May 2007 11:45:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 5/5] SCSI/initio conversion to PCI driver API
References: <20070527145200.GA17017@havoc.gtf.org>	 <20070527145955.GE17085@havoc.gtf.org>  <46599DD9.4020408@garzik.org> <1180278739.3711.16.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1180278739.3711.16.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Sun, 2007-05-27 at 11:03 -0400, Jeff Garzik wrote:
>> Jeff Garzik wrote:
>>> Prior simplifications in this patchset now permit a minimal conversion
>>> to the new PCI API.
>>>
>>> Further improvements and simplifications are certainly possible; those
>>> should be presented in a separate patchset.
>>>
>>> DO NOT APPLY (yet).  For feedback (and testers?) only.
>>
>> This only applies to patch #5.
>>
>> Patches 1 through 4 should go upstream, IMO.
> 
> Erm, actually, you're treading all over Alan:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=72d39fea9017bbb1407620bf89dfe8d1fb658e35
> 
> Could you rebase your patches to scsi-misc-2.6 and resubmit (if there's
> anything Alan hasn't covered)?


Hey, if it's tested at least minimally that's the minimum I hoped to 
achieve.  It sounds like you can drop all patches, though if it takes 
forever for scsi-misc-2.6 to go upstream, users in the interim will be 
denied the make-it-actually-work fix provided in patch #1, if that matters.

	Jeff


