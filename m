Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbXGVJHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbXGVJHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761242AbXGVJHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:07:01 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36875 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761120AbXGVJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:07:00 -0400
Date: Sun, 22 Jul 2007 11:06:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070721224300.GB18326@mail.linbit.com>
Message-ID: <Pine.LNX.4.64.0707221105480.15705@fbirervta.pbzchgretzou.qr>
References: <20070721203819.GA10706@mail.linbit.com>
 <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr>
 <20070721224300.GB18326@mail.linbit.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22 2007 00:43, Lars Ellenberg wrote:
>On Sat, Jul 21, 2007 at 11:17:43PM +0200, Jan Engelhardt wrote:
>> On Jul 21 2007 22:38, Lars Ellenberg wrote:
>> >
>> >We implement shared-disk semantics in a shared-nothing cluster.
>> 
>> If nothing is shared, the disk is not shared, but got shared-disk
>> semantics? A little confusing.
>
>Think of it as RAID1 over TCP.

And what does it do better than raid1-over-NBD? (Which is already N-disk,
and, logically, seems to support cluster filesystems)

>Typically you have one Node in Primary, the other as Secondary,
>replication target only.
>But you can also have both Active, for use with a cluster file system.
>
>So the semantics are like you have
>two (to come: N) nodes and a shared disk.
>only that there is not one shared disk,
>but two (N) replicated ones.
>
>btw, regarding linux kernel CodingStyle issues.
>scripts/checkpatch.pl reports 2000+ lines of complaints.
>I'm working on it now, it is mostly whitespace (lame excuse: phil grew
>up with emacs and gnu coding style, sorry for that).
>

	Jan
-- 
