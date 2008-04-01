Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYDAIo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYDAIo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYDAIow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:44:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:54056 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753873AbYDAIov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:44:51 -0400
Date: Tue, 1 Apr 2008 10:44:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
In-Reply-To: <20080401084308.GA4787@elte.hu>
Message-ID: <Pine.LNX.4.64.0804011043540.5541@jikos.suse.cz>
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz>
 <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz> <20080401083359.GB32272@elte.hu>
 <Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz> <20080401084308.GA4787@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Ingo Molnar wrote:

> > In fact we have received report from one of our users that he is 
> > seeing approximately 15% performance degradation of mmap() when 
> > spinlocks are not inlined. I am going to do some performance 
> > measurements myself shortly, as it seems quite strange, but while at 
> > it, I have noticed the aforementioned asymetry in spinlock.h, so I 
> > just wanted to know if there is any particular reason behind that.
> inlining decisions almost never have effects of that order of magnitude 
> - especially on new CPUs, so that 15% looks quite suspicious to me. 

Definitely, that's why I am a little bit suspicious. Thanks,

-- 
Jiri Kosina
SUSE Labs
