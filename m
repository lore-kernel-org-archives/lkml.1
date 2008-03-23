Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYCWQ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYCWQ30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 12:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYCWQ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 12:29:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYCWQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:29:16 -0400
Message-ID: <47E68423.2010507@zytor.com>
Date: Sun, 23 Mar 2008 09:24:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ultrastor.c is a bit-rot
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org> <47E41D7D.9050409@zytor.com> <47E628DF.6070301@panasas.com>
In-Reply-To: <47E628DF.6070301@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On Fri, Mar 21 2008 at 22:41 +0200, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> Matthew Wilcox wrote:
>>> VESA Local Bus.  It was (in some sense) the predecessor of AGP.  We
>>> treat it like ISA inside the kernel.  On x86, EISA depends on ISA, so
>>> the dependency, while wrong, does not affect any x86 users who have an
>>> EISA card.
>>>
>> Well, one can say VLB was to ISA (a souped-up ISA bus with some of the 
>> worst limitations removed) what AGP is to PCI...
>>
>> 	-hpa
> 
> Hmm interesting, so someone took the VGA thing and made a storage device
> for it. Did that ever happen with AGP? Any AGP scsi cards. I guess I can
> Google for it.

A lot less likely, IMO.  Unlike AGP-PCI, VLB slots were compatible with 
ISA cards, and the electricals were less complex, so several motherboard 
manufacturers built boards with 3 or more VESA slots (I think I saw a 
board with 6 at one point.)

AGP electricals pretty much require that it be point to point.

	-hpa
