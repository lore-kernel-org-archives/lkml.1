Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYGMNfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYGMNfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 09:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYGMNer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 09:34:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbYGMNeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 09:34:46 -0400
Date: Sun, 13 Jul 2008 09:34:33 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: Andi Kleen <andi@firstfloor.org>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <87iqvb2skz.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0807130933120.24489@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com>
 <87iqvb2skz.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mikulas Patocka <mpatocka@redhat.com> writes:
>
>> I'm getting crashes with InitIO A100u2w controller on Sparc64 (I had
>> to fix the endianity issues in the driver, but that's unrelated).
>
> x86-64 (and powerpc) solved this a long time ago by only doing
> opportunistic merging: as in don't announce to the block layer
> that you can merge, but try to merge anyways. This way SG lists
> are not necessarily filled completely, but it's still better
> than overflowing them in some rare cases.
>
> -Andi

There's option "biomerge" that enables that feature. I'm wondering, if 
there's some situation when it should be used.

Mikulas
