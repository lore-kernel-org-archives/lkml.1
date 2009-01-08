Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZAHFHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZAHFHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 00:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZAHFG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 00:06:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZAHFG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 00:06:56 -0500
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
From: Andi Kleen <andi@firstfloor.org>
References: <200901051236.281008835@firstfloor.org>
	<20090104233640.6A7453E6653@basil.firstfloor.org>
	<Pine.LNX.4.64.0901061847110.29408@blonde.anvils>
	<20090107131846.GF3529@elte.hu>
	<Pine.LNX.4.64.0901080119260.30224@blonde.anvils>
Date: Thu, 08 Jan 2009 06:07:04 +0100
In-Reply-To: <Pine.LNX.4.64.0901080119260.30224@blonde.anvils> (Hugh Dickins's message of "Thu, 8 Jan 2009 02:16:26 +0000 (GMT)")
Message-ID: <87aba2xu6f.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> writes:
>
> I think these numbers show that that even gcc 4.4 is not yet ready
> for CONFIG_OPTIMIZE_INLINING=y, but that Andi's patch helps in one
> important area.  grep for something else and maybe a different story.

Thanks Hugh for the excellent numbers. So it looks like the patch is a good
idea even on newer gccs.
 
Should probably file test cases into the gcc bugzilla if 4.4 still
doesn't get it right.  I'll put that on my todo list if noone beats
me.

-Andi

-- 
ak@linux.intel.com
