Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbYEOStm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbYEOStm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYEOStb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:49:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbYEOSta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:49:30 -0400
Date: Thu, 15 May 2008 11:49:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.26-rc2-mm1
Message-Id: <20080515114913.91aa98d0.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0805151044i574d697es8c8c29496d99e8d3@mail.gmail.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<64bb37e0805141212i7587a502vdff9af109b55c37b@mail.gmail.com>
	<20080514123537.4df70e80.akpm@linux-foundation.org>
	<64bb37e0805151044i574d697es8c8c29496d99e8d3@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 19:44:37 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On Wed, May 14, 2008 at 9:35 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 14 May 2008 21:12:13 +0200
> >  "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> >  > This line from 2.6.26-rc2-mm1 really looks like the source of this:
> >  > [    0.000000] SRAT: PXMs only cover 0MB of your 4608MB e820 RAM. Not used.
> >  > There is no more than 4GB of RAM (but part of it is remapped...)
> >
> >  I suspect that this might be caused by the below.
> >
> >  That patch no longer seems to be necessary so I'll drop it.  Perhaps
> >  you could try reverting it, please?
> 
> Yes, reverting the patch below gets the system back to its normal state.
> 

Great, thanks for checking.
