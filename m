Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbZH1NuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbZH1NuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZH1NuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:50:11 -0400
Received: from thunk.org ([69.25.196.29]:36736 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZH1NuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:50:05 -0400
Date: Fri, 28 Aug 2009 09:50:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: ext4 tree build warning
Message-ID: <20090828135004.GG16732@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090827171704.28109c6f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827171704.28109c6f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 05:17:04PM +1000, Stephen Rothwell wrote:
> Hi Ted,
> 
> The linux-next builds (ppc64 allyesconfig) produce this warning:
> (I built with CONFIG_DEBUG_SECTION_MISMATCH=y)
> 
> WARNING: fs/ext4/ext4.o(.text+0x5b6c8): Section mismatch in reference from the function .exit_ext4_mballoc() to the function .exit.text:.ext4_remove_debugfs_entry()
> The function .exit_ext4_mballoc() references a function in an exit section.
> Often the function .ext4_remove_debugfs_entry() has valid usage outside the exit section
> and the fix is to remove the __exit annotation of .ext4_remove_debugfs_entry.

Thanks for pointing that out, I'll get that fixed.

						- Ted
