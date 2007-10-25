Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbXJYUxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbXJYUxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbXJYUx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:53:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbXJYUx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:53:26 -0400
Message-ID: <472101D8.1020104@zytor.com>
Date: Thu, 25 Oct 2007 13:51:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: Hugh Dickins <hugh@veritas.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, ryan@finnie.org,
       mhalcrow@us.ibm.com, cjwatson@ubuntu.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH+comment] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE
References: <200710251601.l9PG1Mue019939@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200710251601.l9PG1Mue019939@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> In message <Pine.LNX.4.64.0710250705510.9811@blonde.wat.veritas.com>, Hugh Dickins writes:
>> On Thu, 25 Oct 2007, Pekka Enberg wrote:
> 
>> With unionfs also fixed, we don't know of an absolute need for this
>> patch (and so, on that basis, the !wbc->for_reclaim case could indeed
>> be removed very soon); but as I see it, the unionfs case has shown
>> that it's time to future-proof this code against whatever stacking
>> filesystems come along.  Hence I didn't mention the names of such
>> filesystems in the source comment.
> 
> I think "future proof" for other stackable f/s is a good idea, esp. since
> many of the stackable f/s we've developed and distributed over the past 10
> years are in some use in various places: gzipfs, avfs, tracefs, replayfs,
> ncryptfs, versionfs, wrapfs, i3fs, and more (see www.filesystems.org).
> 

A number of filesystems want partial or full stackability, so getting 
rid of lack-of-stackability whereever it may be is highly valuable.

	-hpa

