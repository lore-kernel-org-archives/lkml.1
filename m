Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbYBBSBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbYBBSBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYBBSBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:01:42 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34307 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYBBSBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:01:42 -0500
Date: Sat, 2 Feb 2008 19:01:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] Remove __INIT_REFOK and __INITDATA_REFOK
Message-ID: <20080202180144.GA25399@uranus.ravnborg.org>
References: <20080130141408.GA6116@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130141408.GA6116@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 02:14:08PM +0000, Ralf Baechle wrote:
> Commit 312b1485fb509c9bc32eda28ad29537896658cb8 made __INIT_REFOK expand
> into .section .section ".ref.text", "ax".  Since the assembler doesn't
> tolerate stuttering in the source that broke all MIPS builds.
> 
> Since with this change Sam downgraded __INIT_REFOK to just a backward
> compat thing and there being only a single use in the MIPS arch code the
> best solution is to delete both of __INIT_REFOK and __INITDATA_REFOK (which
> was equally broken) being unused anyway these can be deleted.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Thanks Ralf - applied.
And sorry for the MIPS breakage.

	Sam
