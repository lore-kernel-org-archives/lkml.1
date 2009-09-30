Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbZI3QHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbZI3QHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZI3QHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:07:15 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:51649 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbZI3QHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BhCCANBgWxDZ2Nj5CxbIigMXLpTrlurQtkdSvRM3b7Td3olLVxHmg/7dL726quJd+7
         wqLeST1MyaoJmyOo5vYiCvn2dMEpFkdD7N6CPM87O9h10SpiNmrskuQZFdv6LyRU930k
         rDwpJRHVMmf/LDY4sUc19qDhuMADMraJH7mDo=
MIME-Version: 1.0
In-Reply-To: <20090930130815.GA4134@cmpxchg.org>
References: <4AB9A0D6.1090004@crca.org.au> <Pine.LNX.4.64.0909232056020.3360@sister.anvils> 
	<4ABC7FBC.4050409@crca.org.au> <20090930120202.GB1412@ucw.cz> 
	<20090930130815.GA4134@cmpxchg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 30 Sep 2009 12:06:58 -0400
Message-ID: <8bd0f97a0909300906k283e3fd2q80705dbf78588cac@mail.gmail.com>
Subject: Re: swsusp on nommu, was 'Re: No more bits in vm_area_struct's 
	vm_flags.'
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <ncunningham@crca.org.au>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 09:08, Johannes Weiner wrote:
> On Wed, Sep 30, 2009 at 02:02:03PM +0200, Pavel Machek wrote:
>> > > Does TuxOnIce rely on CONFIG_MMU?  If so, then the TuxOnIce patch
>> > > could presumably reuse VM_MAPPED_COPY for now - but don't be
>> > > surprised if that's one we clean away later on.
>> >
>> > Hmm. I'm not sure. The requirements are the same as for swsusp and
>> > uswsusp. Is there some tool to graph config dependencies?
>>
>> I don't think swsusp was ported on any -nommu architecture, so config
>> dependency on MMU should be ok. OTOH such port should be doable...
>
> I am sitting on some dusty patches to split swapfile handling from
> actual paging and implement swsusp on blackfin.  They are incomplete
> and I only occasionally find the time to continue working on them.  If
> somebody is interested or also working on it, please let me know.

suspend to ram works on Blackfin systems w/out a problem, and i cant
think of a reason off the top of my head as to why saving/restoring
the image to disk couldnt work w/out a mmu ...

last time we looked, we found it too coupled to mmu code and we didnt
have a lot of pressure to get it done, so we moved on to other things.
-mike
