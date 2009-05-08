Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbZEHKIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbZEHKIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZEHKH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:07:56 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36587 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831AbZEHKHz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:07:55 -0400
X-BigFish: VPS-25(zz1432R98dR1805M936fJzz1202hzzz32i6bh6di)
X-FB-SS: 5,
X-WSS-ID: 0KJBLGS-02-HU6-01
Date: Fri, 8 May 2009 12:07:38 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Message-ID: <20090508100738.GA21064@aftab>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com> <20090507142724.GM481@elte.hu> <20090507143807.GA15923@aftab> <20090507135227.abbbc7dc.akpm@linux-foundation.org> <20090507211859.GA28770@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090507211859.GA28770@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 08 May 2009 10:07:42.0177 (UTC) FILETIME=[D3442D10:01C9CFC4]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 07, 2009 at 11:18:59PM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 7 May 2009 16:38:07 +0200
> > Borislav Petkov <borislav.petkov@amd.com> wrote:
> > 
> > > Hi,
> > > 
> > > On Thu, May 07, 2009 at 04:27:24PM +0200, Ingo Molnar wrote:
> > > > Regarding workflow, the arch/x86 bits look good to me now, so you've 
> > > > got my Acked-by for that.
> > > 
> > > Cool, thanks.
> > > 
> > > Does that mean you're going to pick that one or...
> > > 
> > > > Most of the EDAC patches are hosted in 
> > > > -mm, so we could carry them in the x86 tree separately as well and 
> > > > export it to linux-next so that -mm will have it automatically.
> > > 
> > > is the bunch going through Andrew as a whole?
> > > 
> > 
> > I could.  But there's negligible overlap with other EDAC work so 
> > we might as well merge this via IngoTrees or directly from your 
> > tree.
> 
> If Doug and you agrees too then i have no problem (at all) with 
> Borislav carrying these bits in a separate tree, as long as he also 
> opens an edac-next branch for linux-next and asks Stephen to pull 
> it, and keeps it an append-mostly tree that isnt rebased.

I'll still need to rebase stuff to latest Linus tree for now since we're
not yet ready reorganizing/cleaning up the code. After it gets merged,
I'll switch to append-only mode.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

