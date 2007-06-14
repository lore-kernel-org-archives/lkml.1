Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXFNBPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXFNBPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbXFNBPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:15:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:12206 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbXFNBPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:15:07 -0400
Date: Thu, 14 Jun 2007 03:15:06 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: DRI/AGP on AMD64 based machine
Message-ID: <20070614011506.GA30566@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613162925.GG3875@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 12:29:25PM -0400, Dave Jones wrote:
> For the sake of AGP, we only use the on-CPU GART.
> The (nvidia) chipset one is ignored.
> 
> If amd64-agp isn't working for you, attach your dmesg.
> (You can also confirm its working by running testgart[1])

Hi Dave, I have an amd64 box for which every kernel
after 2.6.18 hangs during boot, so I have no dmesg :(

I used git bisect to find out where the problem patch is,
and assuming bisect works (imho it jumped between versions
very weirdly: closing in on the last 6 revisions, it
jumped from 2.6.18 to 2.6.18-rc2 to 2.6.18-rc6), the problem
is a patch in intel-agp.c, where support for the intel 965G
is added (which I have).

I mailed the author of the patch, including the git Id
of that patch... but he didn't reply... and I didn't keep the
mail :/ So, I am afraid I can't give much details.

I'd still like to have it sorted out. If you give me the
green light (in the sense that you are willing to help
a kernel-newbie when needed) then I'll have another
attempt at getting more information.

-- 
Carlo Wood <carlo@alinoe.com>

PS I believe it was you who committed the patch.

