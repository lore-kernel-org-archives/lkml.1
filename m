Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZBKMVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZBKMVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZBKMVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:21:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:50600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZBKMVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:21:39 -0500
Subject: Re: next-20090211: BUG: MAX_LOCKDEP_SUBCLASSES too low!
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <a4423d670902110414r72f14c1eq850cda59533bd9db@mail.gmail.com>
References: <a4423d670902110414r72f14c1eq850cda59533bd9db@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Feb 2009 13:23:30 +0100
Message-Id: <1234355010.23438.132.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 15:14 +0300, Alexander Beregalov wrote:
> Hi
> 
> Full dmesg is attached.
> 
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> .... MAX_LOCKDEP_SUBCLASSES:  8
> .... MAX_LOCK_DEPTH:          48
> .... MAX_LOCKDEP_KEYS:        8191
> .... CLASSHASH_SIZE:          4096
> .... MAX_LOCKDEP_ENTRIES:     8192
> .... MAX_LOCKDEP_CHAINS:      16384
> .... CHAINHASH_SIZE:          8192
>  memory used by lock dependency info: 4351 kB
>  per task-struct memory footprint: 2688 bytes
> <..>
> BUG: MAX_LOCKDEP_SUBCLASSES too low!
> turning off the locking correctness validator.

Is this an allyesconfig or something other massive bloated?
