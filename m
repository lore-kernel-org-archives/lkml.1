Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbYD3BLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbYD3BLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbYD3BLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:11:06 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34022 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbYD3BLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:11:05 -0400
Message-Id: <D8E7FEBEEB9649CF9E2FC389BC5F8C6B@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
       <dm-devel@redhat.com>, <xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>
References: <20080428193123t-sato@mail.jp.nec.com> <20080428103719.GA16030@infradead.org> <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp> <20080428130358.GB2798@infradead.org>
In-Reply-To: <20080428130358.GB2798@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Wed, 30 Apr 2008 10:10:13 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> bd_mount_sem can protect against only freezes and cannot protect against
>> unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
>> bd_mount_sem might occur incorrectly.
>
> Indeed.  The bit flag would fix that because unfreeze could then check
> for the bit beeing set first.  So that's probably the easiest way to go.

I think the bit flag is more efficient than the semaphore.
So I will consider whether it can be used for the freeze feature.

Cheers, Takashi
