Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZDBHjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZDBHjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762636AbZDBHjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:39:05 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:45648 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031AbZDBHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:39:03 -0400
Date: Thu, 2 Apr 2009 09:38:52 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cotte@de.ibm.com,
       npiggin@suse.de, jaredeh@gmail.com
Subject: Re: [PATCH] do_xip_mapping_read: fix length calculation
Message-ID: <20090402093852.30bbf3e9@skybase>
In-Reply-To: <20090401141700.f5ef3c08.akpm@linux-foundation.org>
References: <20090331153223.74b177bd@skybase>
	<20090401141700.f5ef3c08.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 14:17:00 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 31 Mar 2009 15:32:23 +0200
> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
>
> Please get into the habit of adding Cc: <stable@kernel.org> to the
> changelogs?

Ok, I've made me a sticky note and attached it to my monitor. Perhaps
that will help me to remember .. 

> I believe I personally am pretty good at picking up stable things, but
> other patch-mergers are quite unreliable.  We all need as much help as
> we can get on this, because things are falling through cracks.

Ok, makes sense. Better safe than sorry.
 
> > With this bug fix the commit 0e4a9b59282914fe057ab17027f55123964bc2e2
> > "ext2/xip: refuse to change xip flag during remount with busy inodes"
> > can be removed again.
> 
> OK, please send a standalone patch to do this at an appropriate time. 
> I guess that this second patch won't be needed in -stable.
 
The revert should be done either with the bug fix or after the bug fix
hit mainline. Guess I just create the patch and send it.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

