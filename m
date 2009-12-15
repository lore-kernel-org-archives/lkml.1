Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbZLORGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbZLORGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZLORGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:06:17 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58037 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbZLORGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:06:16 -0500
Date: Tue, 15 Dec 2009 11:06:14 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org
Subject: Re: [patch 0/8] x86: UV - XPC fixes with related support
	functionality V2.
Message-ID: <20091215170614.GK8934@sgi.com>
References: <20091124013937.354595000@alcatraz.americas.sgi.com> <20091215170439.GJ8934@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215170439.GJ8934@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh.  Forget it.  I see them now.  I am sorry for the noise.

Robin

On Tue, Dec 15, 2009 at 11:04:39AM -0600, Robin Holt wrote:
> Andrew, did this get lost in the shuffle?  If you need me to
> resubmit, please let me know.
> 
> Thanks,
> Robin
> 
> On Mon, Nov 23, 2009 at 07:39:37PM -0600, Robin Holt wrote:
> > 
> > The UV BIOS has been updated to implement some of our interface
> > functionality differently than originally expected.  These patches update
> > the kernel to the bios implementation and include a few minor bug fixes
> > which prevent us from doing significant testing on real hardware.
> > 
> > Changes from V1:
> > 
> > - Actually include the patch introducing the gru_read_gpa.  This
> >   was missed in the V1 submission.
> > 
> > - One additional BIOS change has the OS no longer passing blade
> >   to the BIOS when registering a message queue watchlist.
> > 
> > ---
> > 
> >  arch/x86/include/asm/uv/bios.h          |   11 --------
> >  arch/x86/include/asm/uv/uv_hub.h        |   20 +++++++++++++++
> >  arch/x86/kernel/bios_uv.c               |    8 +-----
> >  drivers/misc/sgi-gru/gru_instructions.h |   13 ++++++++++
> >  drivers/misc/sgi-gru/grukservices.c     |   23 +++++++++++++++++
> >  drivers/misc/sgi-gru/grukservices.h     |   14 ++++++++++
> >  drivers/misc/sgi-gru/gruprocfs.c        |    1 
> >  drivers/misc/sgi-gru/grutables.h        |    1 
> >  drivers/misc/sgi-xp/xp.h                |    1 
> >  drivers/misc/sgi-xp/xp_main.c           |    3 ++
> >  drivers/misc/sgi-xp/xp_sn2.c            |   10 +++++++
> >  drivers/misc/sgi-xp/xp_uv.c             |   33 +++++++++++++++++++++++++
> >  drivers/misc/sgi-xp/xpc_partition.c     |   13 +++++++---
> >  drivers/misc/sgi-xp/xpc_uv.c            |   41 +++++++++++++++++---------------
> >  14 files changed, 153 insertions(+), 39 deletions(-)
