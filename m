Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYLIVk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYLIVk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYLIVkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:40:47 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59529
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYLIVkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:40:46 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@suse.cz>
Subject: Re: Document hadling of bad memory
Date: Tue, 9 Dec 2008 15:40:41 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
References: <20081126161521.GC1983@elf.ucw.cz> <20081201105625.25ee9f32.randy.dunlap@oracle.com> <20081209123152.GA1547@ucw.cz>
In-Reply-To: <20081209123152.GA1547@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091540.42429.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2008 06:31:52 Pavel Machek wrote:
> I cleaned the document up according to Randy (thanks!). I don't actually
> know enough about DRAM error characcteristics, I guess'round the size of
> bad region up to nearest 2^n makes sense.
>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
> diff --git a/Documentation/bad_memory.txt b/Documentation/bad_memory.txt
...
> +This Howto is about number 3).
>
>
>  BadRAM
>  ######
> -BadRAM is the actively developed and available as kernel-patch
> +BadRAM is the actively developed and available as a kernel patch
>  here:  http://rick.vanrein.org/linux/badram/

Ok, once again: the point of this patch is to document an out of tree patch.

The out of tree patch is here:
http://rick.vanrein.org/linux/badram/software/BadRAM-2.6.27.1.patch

It has its own Documentation/badram.txt file and it patches 
Documentation/memory.txt, as acknowledged here:

>  For more details see the BadRAM documentation.
> @@ -27,19 +27,20 @@ For more details see the BadRAM documentation.
>  memmap
>  ######

Now what I don't understand is, why add something to the tree formalizing the 
out-of-tree status of this other patch?  Why not just merge it?  If it's 
interesting enough to have documentation about the patch in the tree, why is 
the patch itself not interesting enough to merge?  It's clearly got an active 
maintainer, and has for years.  (Is there something specific about it that 
needs to be cleaned up?)

Adding this extra documentation to the badram patch sounds great.  Merging the 
badram patch into the linux kernel sounds useful; obviously _this_ patch is 
inherently an expression of interest in it.  Adding documentation about the 
badram patch to the linux kernel tree but _not_ adding the badram patch itself 
seems kind of crazy.

Would someone please explain the reasoning here?  I don't understand it.

Rob
