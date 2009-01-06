Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZAFX1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZAFX1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZAFX1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:27:02 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:24791 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbZAFX1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:27:00 -0500
Message-ID: <e37d376a0901061526s3bccb71rb07087e2716159b9@mail.gmail.com>
Date: Tue, 6 Jan 2009 15:26:59 -0800
From: "Warren Turkal" <wt@penguintechs.org>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: 2.6.29 -mm merge plans
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Diego Elio 'Flameeyes' Petten?" <flameeyes@gmail.com>
In-Reply-To: <e37d376a0901061526s5d571febu2eb9758050506442@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <20090106225744.GA10553@infradead.org>
	 <20090106151747.c640dfd4.akpm@linux-foundation.org>
	 <20090106231958.GA30271@infradead.org>
	 <e37d376a0901061526s5d571febu2eb9758050506442@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to clarify, by "previous code", I meant I linked to it. It is not
the code I used for the patch.

wt

On Tue, Jan 6, 2009 at 3:26 PM, Warren Turkal <wt@penguintechs.org> wrote:
> I have a drive at home with the condition. So empirically, it can happen.
>
> I would also argue that having a journal bit set and then saying that
> the journal info block is at 0 makes no sense anyhow since the first
> 1024 bytes of the volume must be empty on HFS+.
>
> And, I found the previous code from Apple saying that a 0 in the
> journal_info_block field indicated that there was no journal.
>
> Is there anything else I should be doing?
>
> wt
>
> On Tue, Jan 6, 2009 at 3:19 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Tue, Jan 06, 2009 at 03:17:47PM -0800, Andrew Morton wrote:
>>> > I'm pretty sure we already had a version better than that in your
>>> > tree on the list.  But I've lost track and we should just restart
>>> > the review cycle on -fsdevel.
>>>
>>> Yeah, I have the three hfs patches:
>>>
>>> hfsplus-identify-journal-info-block-in-volume-header.patch
>>> hfsplus-fix-journal-detection.patch
>>> hfs-add-basic-export-support.patch
>>>
>>> in a holding pattern awaiting a second round, due to laggy, incomplete
>>> and confusing noises from various people.  It all needs a revisit.
>>
>> The first two are not for me to decide.  They look fine code-wise,
>> but IIRC Roman had some issues with wether the condition should be
>> possible at all.
>>
>> The third one is where I requested a respin, and I'm pretty sure I've
>> seen a version with some improvement over the one in your tree.  Let's
>> get the latests version back on -fsdevel and review it again.
>>
>> The one in your tree certainly is not ready.
>>
>
