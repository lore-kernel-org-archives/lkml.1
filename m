Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbYBFTxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbYBFTxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbYBFTx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:53:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbYBFTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:53:28 -0500
Message-ID: <47AA102F.1070105@zytor.com>
Date: Wed, 06 Feb 2008 11:53:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       Mika Lawando <rzryyvzy@trashmail.net>
Subject: Re: What is the limit size of tmpfs /dev/shm ?
References: <47A9CA0E.3030507@wpkg.org> <Pine.LNX.4.64.0802061517380.8470@blonde.site> <47AA0A2E.30701@zytor.com> <Pine.LNX.4.64.0802061938120.32204@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0802061938120.32204@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> 
> In theory, yes, and should be true in practice before it hits swap.
> But I think you'll find our swap handling is too primitive for tmpfs
> to perform well once we hit swap.  Most filesystems pay considerable
> attention to good performance within their constraints of correctness.
> Whereas with tmpfs we've just never worried about the performance once
> swapping.  It's used so you don't lose your data, but if you're really
> expecting to be going to disk very much, better start with a filesystem
> really designed for that.
> 

That sounds like a problem in our overall swap handling, not 
specifically in tmpfs.  Now, I can't say anything concrete about heavy 
swap conditions, but in light swap conditions I have measured a 20x 
performance improvement(!) over ext3 on real workloads.

	-hpa
