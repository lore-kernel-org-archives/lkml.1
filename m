Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYE2OZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYE2OZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYE2OZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:25:06 -0400
Received: from oss.sgi.com ([192.48.170.157]:58763 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYE2OZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:25:05 -0400
Date: Thu, 29 May 2008 15:20:54 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 8/10] mips: convert to generic helpers for IPI function
	calls
Message-ID: <20080529142054.GA8320@linux-mips.org>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-9-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212051504-12561-9-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 10:58:22AM +0200, Jens Axboe wrote:

> This converts mips to use the new helpers for smp_call_function() and
> friends, and adds support for smp_call_function_single(). Not tested,
> but it compiles.
> 
> mips shares the same IPI for smp_call_function() and
> smp_call_function_single(), since not all hardware has enough available
> IPIs available to support seperate setups.

FYI, the comment isn't quite accurate.  The machanisms for IPIs on MIPS
are platform-specific.  The change which I recently objected to was
specific to a code model called VSMP.

  Raf
