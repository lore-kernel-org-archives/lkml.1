Return-Path: <linux-kernel-owner+w=401wt.eu-S1765635AbXJTL4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765635AbXJTL4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbXJTLz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:55:58 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:3510 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbXJTLz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UbvMz9OY4XyEd+QPfnWpyPcmlgnyUHW7EA6XmwHg7uBzTtxIzvJFAqb25zAYuOyIvLuZ1h9WBqKi6C/k5aEOmZ3HdaHlDxUUKJ0/c5N77jwVpai7BkJOafffOg7R9M/oU+R3zS0PZbTiNtMmG+gYXBMQPvwkdSetYk4G7ApHpek=
Message-ID: <64bb37e0710200455h6a1d7819ibb9ff4f8252aa14b@mail.gmail.com>
Date: Sat, 20 Oct 2007 13:55:55 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [bug] ata subsystem related crash with latest -git
Cc: "Jeff Garzik" <jgarzik@pobox.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20071018083213.GN5063@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071017172932.GI15552@kernel.dk> <20071017174503.GA4622@elte.hu>
	 <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk>
	 <20071017190901.GA13780@elte.hu>
	 <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>
	 <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu>
	 <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Just catching with reading lkml to this post]

On 10/18/07, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> Theory - ata_sg_is_last() isn't returning true for the last entry. Can
> you double check that it correcly marks the last entry in mv_fill_sg()?
> Alternatively, just try this patch.

I "hate" to point this out, but I already reported that sata_sil24
fails on 1. Sep.:
http://lkml.org/lkml/2007/9/1/95

In the thread "sata_sil24 broken since 2.6.23-rc4-mm1" I spent over a
week to trace this back to ata_sg_is_last (finally found on 7. Oct):
http://lkml.org/lkml/2007/10/7/43

Thanks for finally patching this now...

Torsten
