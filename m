Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZD1Idc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZD1Idc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZD1IdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:33:20 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52169 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZD1IdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:33:19 -0400
Date: Tue, 28 Apr 2009 10:35:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@MIT.EDU>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Please revert edada399 and 9203fc9c
Message-ID: <20090428083528.GA17622@uranus.ravnborg.org>
References: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 02:56:33PM +1000, Paul Mackerras wrote:
> Linus,
> 
> Please revert commits edada399 ("powerpc: Use TEXT_TEXT macro in
> linker script.") and 9203fc9c ("powerpc: Use __REF macro instead of
> old .text.init.refok."), which depends on edada399.
> 
> Commit edada399 breaks the build because it moves the __ftr_alt_*
> sections of a file away from the .text section, causing link failures
> due to relative conditional branch targets being too far away from the
> branch instructions.  This happens on pretty much all 64-bit powerpc
> configs.
> 
> Clearly these patches were never even build-tested.  They were never
> acked by the powerpc maintainer (Ben) - because he was on vacation -
> and they weren't sent to the deputy maintainer (me) or the relevant
> mailing list (linuxppc-dev).

This is partly my fault :-(
I acked them as I did not see the issue with conditional branches.
Could I ask you to add a comment to the lds file about this.

	Sam
