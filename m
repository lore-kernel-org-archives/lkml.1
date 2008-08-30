Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYH3WYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYH3WYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbYH3WYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:24:34 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49514 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbYH3WYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:24:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=EO9Z5T4R7tLPu25odyQFhiu6045JorXoFMAVPlldOfaKKjnfAZa9i7zSFF4VH+wiX5H2kOMoz7fNCRI+72EUIhd7Y39v4lEfcVpvjBxXYN4BY/LUj3yGwUZP9UT6kLJW;
Message-ID: <48B9C89D.7050800@simon.arlott.org.uk>
Date: Sat, 30 Aug 2008 23:24:29 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
References: <48B9546B.4010004@simon.arlott.org.uk>	<1220117091.3615.3.camel@localhost.localdomain>	<20080830174516.GD1239@parisc-linux.org>	<20080830225950.4828dcf6@mjolnir.drzeus.cx>	<1220132749.3615.14.camel@localhost.localdomain> <20080831001314.694df795@mjolnir.drzeus.cx>
In-Reply-To: <20080831001314.694df795@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/08 23:13, Pierre Ossman wrote:
> On Sat, 30 Aug 2008 16:45:49 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
>> On Sat, 2008-08-30 at 22:59 +0200, Pierre Ossman wrote:
>> > On Sat, 30 Aug 2008 11:45:16 -0600
>> > Matthew Wilcox <matthew@wil.cx> wrote:
>> > 
>> > > 
>> > > 2. We should report in GB or TB when appropriate.  The exact definition
>> > > of 'appropriate' is going to vary from person to person.  Might I
>> > > suggest that we should report between two and four significant digits.
>> > > eg 9543 MB is ok, 10543 MB should be 10 GB.
>> > > 
>> > 
>> > I've been looking at doing something like this for the mmc_block
>> > driver, so a generic helper is welcome. :)
>> 
>> Does MMC have the 10^3 requirement like SCSI/ATA disks do, or can you
>> use 2^10 like standard computer stuff for capacities?
>> 
> 
> Some do, some don't. I prefer the 2^10 and MiB variants as it avoids
> ambiguity.

If there's a generic function to do this, there could be a Kconfig option 
to select the variant (10^3 MB, 2^10 MiB, 2^10 MB ;)), as long as the byte 
value is available from the same message.

-- 
Simon Arlott
