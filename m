Return-Path: <linux-kernel-owner+w=401wt.eu-S1763827AbYEHPoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763827AbYEHPoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYEHPoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:44:38 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55533 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbYEHPog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:44:36 -0400
Date: Thu, 8 May 2008 08:44:31 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080508154431.GL23990@us.ibm.com>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com> <1210106579.4747.51.camel@nimitz.home.sr71.net> <20080508143453.GE12654@escobedo.amd.com> <1210258350.7905.45.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210258350.7905.45.camel@nimitz.home.sr71.net>
X-Operating-System: Linux 2.6.25-mm1-00024-g164d446 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.2008 [07:52:30 -0700], Dave Hansen wrote:
> On Thu, 2008-05-08 at 16:34 +0200, Hans Rosenfeld wrote:
> > While trying to reproduce this, I noticed that the huge page wouldn't
> > leak when I just mmapped it and exited without explicitly unmapping, as
> > I described before. The huge page is leaked only when the
> > /proc/self/pagemap entry for the huge page is read.
> 
> Well, that's an interesting data point! :)

Indeed it is! Would explain why we've not seen any leaks until now. I
will try to investigate, as well.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
