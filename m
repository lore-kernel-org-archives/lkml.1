Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYJPPQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYJPPQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYJPPQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:16:03 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48620 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752726AbYJPPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:16:01 -0400
Date: Thu, 16 Oct 2008 11:15:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: ext2, ext3, ext4 config headlines inconsistent:
Message-ID: <20081016151559.GB12962@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <adaod1nvx98.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaod1nvx98.fsf@cisco.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 11:37:23AM -0700, Roland Dreier wrote:
> Hi Ted,
> 
> While running an oldconfig with the new kernel, I got the following prompt:
> 
>     Second extended fs support (EXT2_FS) [N/m/y/?] n
>     Ext3 journalling file system support (EXT3_FS) [N/m/y/?] n
>     The Extended 4 (ext4) filesystem (EXT4_FS) [N/m/y/?] (NEW) n
> 
> the lack of parallelism in the headline prompts is a little jarring.
> Any interest in a patch to make this look uniform, or is it not worth
> it?  If you are interested, which variant do you prefer?

I'll note that we don't have consistency across all of the entries in
fs/Kconfig, not just ext2/ext3/ext4.  If it were just up to me I'd
probably prefer:

    Ext2 file system support (EXT2_FS) [N/m/y/?] n
    Ext3 file system support (EXT3_FS) [N/m/y/?] n
    Ext4 file system support (EXT4_FS) [N/m/y/?] (NEW) n

... but it might be worth looking at the other entries in fs/Kconfig
as well.

						- Ted
