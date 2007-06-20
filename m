Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXFTWjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXFTWjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbXFTWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:39:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755916AbXFTWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:39:39 -0400
Date: Wed, 20 Jun 2007 15:38:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ian McDonald <ian.mcdonald@jandi.co.nz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
In-Reply-To: <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com>
 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ian McDonald wrote:
> 
> Can this one be merged so that it makes it into 2.6.22?
> 
> > 
> > Subject    : CONFIG_DEBUG_RODATA prevents kprobes from working on 2.6.22-rc2
> > References : http://lkml.org/lkml/2007/5/23/202
> > Submitter  : William Cohen <wcohen@redhat.com>
> >              Ian McDonald <ian.mcdonald@jandi.co.nz>
> > Handled-By : S. P. Prasanna <prasanna@in.ibm.com>
> > Patch      : http://lkml.org/lkml/2007/6/7/2
> > Status     : patch available
> > 
> 
> Regards,

Well, for 2.6.22, Kprobes will just be disabled if you use DEBUG_RODATA.

And yes, that patch already got merged. However, the patch to *allow* 
Kprobes with DEBUG_RODATA is not, and will not be. It's not a regression, 
and quite frankly, I don't think I would even want that patch.

Kprobes fundamntally disagrees with DEBUG_RODATA, there's no point in 
"working around it". Better just admit it.

		Linus
