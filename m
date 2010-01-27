Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122Ab0A0XlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0A0XlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636Ab0A0XlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:41:24 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:52215 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0A0XlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Kw3sLvCglf8kq1WOEtVtC/R1DuNo1X79D5P10O63AKEVS0d73rKdsk0pINVuA0lm3R
         /QgEU8L2WIjpORk+rivXWYyVRNaQZvpol+UgDULcfa+3DGTJQf3CKCcmle9uL99bKN81
         VrDuAHXcONA28CIFMNEh3/FuV5PpDDgQEZyuY=
MIME-Version: 1.0
In-Reply-To: <aacba7e1001271516k3bb82a0fq7e019b28f3b8972f@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com> 
	<20100126160243.018b87e3@lxorguk.ukuu.org.uk> <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com> 
	<72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com> 
	<aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com> 
	<72dbd3151001261632t7bbe43d0nb7490eae02185c81@mail.gmail.com> 
	<20100127010204.7976c38b@lxorguk.ukuu.org.uk> <aacba7e1001261714n42a68824k62c411cd1e5d7893@mail.gmail.com> 
	<4B60C1C0.8050402@teksavvy.com> <aacba7e1001271516k3bb82a0fq7e019b28f3b8972f@mail.gmail.com>
From: David Rees <drees76@gmail.com>
Date: Wed, 27 Jan 2010 15:41:02 -0800
Message-ID: <72dbd3151001271541l7026389fgd2c91f9ee6502472@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
To: Vishal Rao <vishalrao@gmail.com>
Cc: Mark Lord <kernel@teksavvy.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 3:16 PM, Vishal Rao <vishalrao@gmail.com> wrote:
> 2010/1/28 Mark Lord <kernel@teksavvy.com>:
>> The errors in that log indicate bad media.
>> So the question is, can you demonstrate Win7rc NOT having the same
>> errors when accessing the SAME (logical) sectors ?
>
> Would that mean I have to blow away my precious ext4 partitions and
> have them Win7rc NTFS formatted and run a full check-disk with
> bad block checking enabled?

No - you just need a tool to do a full read of the partition.  You
could use the cygwin tools and dd, for example.

> In the mean time, can I run a linux command (please tell me what it is or
> I will search for something to run online) or tool while NCQ is disabled (via
> libata.force=noncq) that can do a disk scan with bad block checking?

badblocks <name of partition>

See the man page for more details, but that should do a read test -
may want to boot from a rescue disk or from another disk if possible
to run the test.

-Dave
