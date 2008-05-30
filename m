Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYE3HYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYE3HYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYE3HXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:23:49 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10617 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYE3HXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:23:48 -0400
Date: Fri, 30 May 2008 09:23:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 8/10] mips: convert to generic helpers for IPI function  calls
Message-ID: <20080530072346.GH25504@kernel.dk>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-9-git-send-email-jens.axboe@oracle.com> <20080529142054.GA8320@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529142054.GA8320@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29 2008, Ralf Baechle wrote:
> On Thu, May 29, 2008 at 10:58:22AM +0200, Jens Axboe wrote:
> 
> > This converts mips to use the new helpers for smp_call_function() and
> > friends, and adds support for smp_call_function_single(). Not tested,
> > but it compiles.
> > 
> > mips shares the same IPI for smp_call_function() and
> > smp_call_function_single(), since not all hardware has enough available
> > IPIs available to support seperate setups.
> 
> FYI, the comment isn't quite accurate.  The machanisms for IPIs on MIPS
> are platform-specific.  The change which I recently objected to was
> specific to a code model called VSMP.

So s/hardware/platform and you are happy?

-- 
Jens Axboe

