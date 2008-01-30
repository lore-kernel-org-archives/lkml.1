Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYA3XBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYA3XBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761170AbYA3XAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:00:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760889AbYA3XAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:00:44 -0500
Date: Wed, 30 Jan 2008 15:00:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: Compilation fixes
Message-Id: <20080130150009.f1d2d162.akpm@linux-foundation.org>
In-Reply-To: <20080130150737.GE16140@duck.suse.cz>
References: <20080130150737.GE16140@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 16:07:37 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hi,
> 
>   the patch below makes UDF compile in -mm kernel (against 2.6.24-rc8-mm1).
> Please apply.
> 
> 									Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> ---
> 
> Make UDF compile - fixes fallout from previous cleanup patches.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/ialloc.c linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/fs/udf/ialloc.c

Please prefer to put not-for-the-changelog text after the "^---" rather
than prior to the changelog.

When fixing compile errors and warnings, please always quote the compiler
output so we can see what is being fixed.

This patch doesn't apply to my tree and UDF presently compiles OK.  And it
compiled OK in 2.6.24-rc8-mm1 so I am at a loss to know what's going on
here.

Please check http://userweb.kernel.org/~akpm/mmotm/ with your mysteryconfig
and see if we still need any fixes.   Beware that this mmotm snapshot is full
of git conflicts which I haven't bothered fixing (because they're different each
time I pull the trees).  But UDF compiles OK.


