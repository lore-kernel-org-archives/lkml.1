Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbXEQVvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbXEQVvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEQVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:51:15 -0400
Received: from twin.jikos.cz ([213.151.79.26]:40064 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbXEQVvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:51:14 -0400
Date: Thu, 17 May 2007 23:50:19 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
cc: Jan Kratochvil <honza@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0705172348310.27422@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
 <20070511125629.3df919cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
 <20070511133651.63f8a14d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
 <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
 <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Jan Kratochvil wrote:

> This patch is using mmap()'s randomization functionality in such a way 
> that it maps the main executable of (specially compiled/linked 
> -pie/-fpie) ET_DYN binaries onto a random address (in cases in which 
> mmap() is allowed to perform a randomization). Origin of this patch is 
> in exec-shield (http://people.redhat.com/mingo/exec-shield/)
> Signed-off-by: Jan Kratochvil <honza@jikos.cz>

Andrew,

if you are going to merge this, you could add

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

to this patch, if it makes any difference.

Ingo, do you have any opinion on merging this upstream please?

Thanks,

-- 
Jiri Kosina
