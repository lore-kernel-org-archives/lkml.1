Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZLSVSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZLSVSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZLSVSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:18:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58269 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZLSVSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:18:34 -0500
Date: Sat, 19 Dec 2009 22:18:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/2] SYSCTL: Make bin_table not const
Message-ID: <20091219211831.GA19716@basil.fritz.box>
References: <20091219358.549678091@firstfloor.org> <20091219145832.A0424B158A@basil.firstfloor.org> <alpine.LFD.2.00.0912190929180.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912190929180.3712@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 09:40:56AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 19 Dec 2009, Andi Kleen wrote:
> > 
> > Turn all the bin_tables from const to non-const. This is needed for the next
> > patch. Unfortunately there were a lot of them, so the patch is rather 
> > large, but it is completely mechanic. 
> 
> Ouch. I hate this.
> 
> I'd much rather have a constant sysctl bin_table.

Understood. I'll poke at that and try to come up with a tested patch
tomorrow or so.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
