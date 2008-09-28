Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYI1OHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYI1OHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 10:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYI1OG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 10:06:57 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49301 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYI1OG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 10:06:56 -0400
Date: Sun, 28 Sep 2008 10:06:33 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Daniel Rosenthal <danielrosenthal@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux object file containing all kernel symbols and suitable
	for userspace linking?
Message-ID: <20080928140633.GA4956@c2.user-mode-linux.org>
References: <4b6fba110809271957t78d7c0c6m97b2b6c1386f7700@mail.gmail.com> <4httd4pt37d715nqfvge2fau7nahbq6u3a@4ax.com> <4b6fba110809280022x4e10a068s479dd3d2fd67e9ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b6fba110809280022x4e10a068s479dd3d2fd67e9ba@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 03:22:48AM -0400, Daniel Rosenthal wrote:
> It's looks close, but it seems to be missing some symbols.  Below is
> an excerpt of some of the some of the error messages that come up when
> trying to link vmlinux.o to another object file.  It looks like all
> the binary layout related symbols are missing, and jiffies also.
> How/when are these symbols normally linked into the final kernel
> image?

These are proided by the linker script.

      	  	     Jeff

-- 
Work email - jdike at linux dot intel dot com
