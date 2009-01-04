Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZADPtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZADPtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZADPtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:49:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33631 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZADPtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:49:09 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adam Nielsen <a.nielsen@shikadi.net>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>, agk@redhat.com
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 2015 of file fs/xfs/xfs_da_btree.c
From: Andi Kleen <andi@firstfloor.org>
References: <49600DE6.2080108@shikadi.net>
	<20090104074659.GA16775@infradead.org> <49607B5B.3070707@shikadi.net>
	<20090104092349.GA26194@infradead.org>
	<20090104114425.241f6630@lxorguk.ukuu.org.uk>
	<20090104153401.GA16185@infradead.org>
Date: Sun, 04 Jan 2009 16:50:24 +0100
In-Reply-To: <20090104153401.GA16185@infradead.org> (Christoph Hellwig's message of "Sun, 4 Jan 2009 10:34:01 -0500")
Message-ID: <87aba7jcjj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:
>
>> Of course certain distributions default to using LVM for all their file
>> systems which is completely and mindbogglingly bogus. That both messes up
>> barriers in some cases and takes a good 10-20% off performance when I've
>> benched it.
>
> The thing is that there's no reason for that at all with just a single
> underlying disk. 

I've submitted patches to do exactly that in DM some time ago. 
Unfortunately they still didn't make it in (as of 2.6.29 git) for unknown reasons.

-Andi
-- 
ak@linux.intel.com
