Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbYBFV65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbYBFV65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbYBFV6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:58:46 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47436 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbYBFV6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:58:45 -0500
Date: Wed, 6 Feb 2008 21:58:24 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       Mika Lawando <rzryyvzy@trashmail.net>
Subject: Re: What is the limit size of tmpfs /dev/shm ?
In-Reply-To: <47AA102F.1070105@zytor.com>
Message-ID: <Pine.LNX.4.64.0802062150440.16791@blonde.site>
References: <47A9CA0E.3030507@wpkg.org> <Pine.LNX.4.64.0802061517380.8470@blonde.site>
 <47AA0A2E.30701@zytor.com> <Pine.LNX.4.64.0802061938120.32204@blonde.site>
 <47AA102F.1070105@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, H. Peter Anvin wrote:
> 
> That sounds like a problem in our overall swap handling, not specifically in
> tmpfs.  Now, I can't say anything concrete about heavy swap conditions, but in
> light swap conditions I have measured a 20x performance improvement(!) over
> ext3 on real workloads.

Wow, I'm surprised.  I suppose I do jump to thinking of heavy swapping
when light swapping won't be so bad; but even so, 20x ext3 astonishes
me - ext3 wouldn't be anyone's choice for fastest, but even so...

I certainly guess too much and measure too little:
is there a useful test you could point me to?  TIA

Hugh
