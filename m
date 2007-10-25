Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbXJYQDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbXJYQDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXJYQCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:02:51 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33477 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXJYQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:02:50 -0400
Date: Thu, 25 Oct 2007 12:01:22 -0400
Message-Id: <200710251601.l9PG1Mue019939@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       ryan@finnie.org, mhalcrow@us.ibm.com, cjwatson@ubuntu.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH+comment] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE 
In-reply-to: Your message of "Thu, 25 Oct 2007 07:30:08 BST."
             <Pine.LNX.4.64.0710250705510.9811@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0710250705510.9811@blonde.wat.veritas.com>, Hugh Dickins writes:
> On Thu, 25 Oct 2007, Pekka Enberg wrote:

> With unionfs also fixed, we don't know of an absolute need for this
> patch (and so, on that basis, the !wbc->for_reclaim case could indeed
> be removed very soon); but as I see it, the unionfs case has shown
> that it's time to future-proof this code against whatever stacking
> filesystems come along.  Hence I didn't mention the names of such
> filesystems in the source comment.

I think "future proof" for other stackable f/s is a good idea, esp. since
many of the stackable f/s we've developed and distributed over the past 10
years are in some use in various places: gzipfs, avfs, tracefs, replayfs,
ncryptfs, versionfs, wrapfs, i3fs, and more (see www.filesystems.org).

Cheers,
Erez.
