Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbZD1PQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbZD1PQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbZD1PPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:15:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45554 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932409AbZD1PPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:15:33 -0400
Date: Tue, 28 Apr 2009 11:13:48 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 11/14] powerpc: Use macros for .data.page_aligned
 section.
In-Reply-To: <20090429010753.851e0f59.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0904281110350.15450@vinegar-pot.mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu> <1240864388-26315-2-git-send-email-tabbott@mit.edu> <1240864388-26315-3-git-send-email-tabbott@mit.edu> <1240864388-26315-4-git-send-email-tabbott@mit.edu> <1240864388-26315-5-git-send-email-tabbott@mit.edu>
 <1240864388-26315-6-git-send-email-tabbott@mit.edu> <1240864388-26315-7-git-send-email-tabbott@mit.edu> <1240864388-26315-8-git-send-email-tabbott@mit.edu> <1240864388-26315-9-git-send-email-tabbott@mit.edu> <1240864388-26315-10-git-send-email-tabbott@mit.edu>
 <1240864388-26315-11-git-send-email-tabbott@mit.edu> <1240864388-26315-12-git-send-email-tabbott@mit.edu> <20090429010753.851e0f59.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Stephen Rothwell wrote:

> This moves the page_aligned section from a common part of the
> vmlinux.lds to a 32 bit only part.  Was that intentional?

No.  See my reply to this patch from last night 
<http://lkml.org/lkml/2009/4/28/16> and the revised pair of patches in 
reply to that message that replace PATCH 11/14.

	-Tim Abbott
