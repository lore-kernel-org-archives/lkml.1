Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbXCHUY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbXCHUY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933266AbXCHUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:24:28 -0500
Received: from mail.parknet.jp ([210.171.160.80]:4406 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbXCHUY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:24:27 -0500
X-AuthUser: hirofumi@parknet.jp
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: libata: Fix host->simplex_claimed != ap typo
References: <87lki7zuoz.fsf@duaron.myhome.or.jp>
	<20070308160135.78bdef53@lxorguk.ukuu.org.uk>
	<45F02940.5010605@garzik.org>
	<20070308162528.1118fea1@lxorguk.ukuu.org.uk>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Fri, 09 Mar 2007 05:24:18 +0900
In-Reply-To: <20070308162528.1118fea1@lxorguk.ukuu.org.uk> (Alan Cox's message of "Thu\, 8 Mar 2007 16\:25\:28 +0000")
Message-ID: <87abynxz4d.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Thu, 08 Mar 2007 10:18:24 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
>
>> Alan Cox wrote:
>> > On Thu, 08 Mar 2007 23:17:00 +0900
>> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>> > 
>> >> Hi,
>> >>
>> >> the following patch is needed to boot my laptop using pata_ali.ko, at least.
>> >> Please apply.
>> > 
>> > NAK - correct fix is to check != && != NULL. The correct fix was posted
>> > to the list earlier by Vojtech.
>> 
>> You mean Petr Vandrovec I presume?
>
> Sorry got the wrong person - I do indeed

I found the Petr's patch in linux-ide and confirmed it. Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
