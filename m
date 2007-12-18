Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbXLRXKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbXLRXKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXLRXJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:09:59 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43681 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXLRXJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:09:59 -0500
Date: Tue, 18 Dec 2007 18:09:43 -0500
Message-Id: <200712182309.lBIN9haS032087@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] unionfs: restructure unionfs_setattr 
In-reply-to: Your message of "Tue, 18 Dec 2007 22:14:14 GMT."
             <Pine.LNX.4.64.0712182213300.28390@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0712182213300.28390@blonde.wat.veritas.com>, Hugh Dickins writes:
> In order to fix unionfs truncation, we need to move the lower notify_change
> out of the loop in unionfs_setattr.  But when I came to do that, I couldn't
[...]

Hugh, I want to understand how patches 3/4 and 4/4 are related.  In patch 3
you say "in order to fix truncation" but you mention a truncation problem
only in patch 4; is there a patch ordering problem, or they're both related
to the same issue (with 3/4 being a code cleanup, and 4/4 actually fixing
the problem)?

What tests did you conduct to tickle this truncation problem: I assume
fsx-linux through unionfs, mounted on tmpfs?  Did that include both series
of patches (your 9 tmpfs patches, plus the two memcgrpoup?).

Thanks,
Erez.
