Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbXIZUG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbXIZUG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXIZUGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:06:22 -0400
Received: from 1wt.eu ([62.212.114.60]:2706 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbXIZUGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:06:21 -0400
Date: Wed, 26 Sep 2007 22:03:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Timo Jantunen <jeti@welho.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 kills r8169 send performance
Message-ID: <20070926200307.GL10199@1wt.eu>
References: <Pine.LNX.4.64.0709261853110.5869@limbo> <20070926170718.GA4870@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0709262137440.5856@limbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709262137440.5856@limbo>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 09:52:02PM +0300, Timo Jantunen wrote:
> On Wed, 26 Sep 2007, Francois Romieu wrote:
> 
> > The patch below is scheduled for inclusion before 2.6.23. Please try it and
> > see if it makes a difference on top of 2.6.23-rc8 (full dmesg will be welcome
> > too).
> 
> Thanks for the quick reply and fix. Unfortunately the fix didn't help in my 
> case.

In another thread on LKML today, there has been some discussion about a
similar problem, which is caused by a locking bug in iperf which makes
it spin at 100% CPU. Ingo has posted a fix for this, please check the list.

Regards,
Willy

