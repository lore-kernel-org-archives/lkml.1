Return-Path: <linux-kernel-owner+w=401wt.eu-S1766946AbXEBUfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766946AbXEBUfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767004AbXEBUfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:35:11 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54852 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766993AbXEBUfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:35:08 -0400
Date: Wed, 2 May 2007 21:34:51 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Phillip Susi <psusi@cfl.rr.com>
cc: =?UTF-8?B?QmrDtnJuIFN0ZWluYnJpbms=?= <B.Steinbrink@gmx.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Execute in place
In-Reply-To: <4638E6E6.90206@cfl.rr.com>
Message-ID: <Pine.LNX.4.64.0705022131470.15726@blonde.wat.veritas.com>
References: <4637B751.1080907@cfl.rr.com> <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
 <20070502143839.GA31961@atjola.homenet> <Pine.LNX.4.64.0705021616260.31229@blonde.wat.veritas.com>
 <4638E6E6.90206@cfl.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 May 2007 20:35:07.0813 (UTC) FILETIME=[5F5E9D50:01C78CF9]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAQi5TdGVpbmJyaW5rQGdteC5kZQBwc3VzaUBjZmwucnIuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Phillip Susi wrote:
> Hugh Dickins wrote:
> > tmpfs doesn't store its stuff in the page cache twice: that's true,
> > and I didn't mean to imply otherwise.  But tmpfs doesn't contain any
> > support for rom memory: you'd have to copy from rom to tmpfs to use it.
> 
> The question is, when you execute a binary on tmpfs, does its code segment get
> mapped directly where it's at in the buffer cache, or does it get copied to
> another page for the executing process?  At least, assuming this is possible
> due to the vma and file offsets of the segment being aligned.

Its pages are mapped directly into the executing process, without copying.

Hugh
