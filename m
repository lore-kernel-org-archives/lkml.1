Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZJAP0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZJAP0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZJAP0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:26:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54229 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbZJAP0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:26:24 -0400
Date: Thu, 1 Oct 2009 17:26:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20091001152624.GL1656@one.firstfloor.org>
References: <20090930140904.GA6150@one.firstfloor.org> <20090930194049.GA17712@liondog.tnic> <20090930204643.GA24862@elte.hu> <20090930214859.GA28638@elte.hu> <20090930223956.GE17712@liondog.tnic> <20090930230947.GA9346@elte.hu> <20091001141432.GA11410@aftab> <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 07:34:11AM -0700, Linus Torvalds wrote:
> Of course, if it _requires_ being loaded early for some other reason, then 
> that's a different issue. But don't do it just because we don't have the
> 
> 	#define early_initcall(fn)               module_init(fn)
> 
> line.

Or just drop the patch like I proposed. I don't think it serves 
a very useful purpose anyways.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
