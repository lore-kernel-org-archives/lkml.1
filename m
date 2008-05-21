Return-Path: <linux-kernel-owner+w=401wt.eu-S934530AbYEUICl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934530AbYEUICl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYEUICZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:02:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbYEUICX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:02:23 -0400
Date: Wed, 21 May 2008 10:02:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Michael A. Halcrow" <mhalcrow@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] eCryptFS: fix missed mutex_unlock
Message-ID: <20080521080205.GA11087@elte.hu>
References: <20080518142611.GA18000@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080518142611.GA18000@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Ingo, could you please apply it and test? Actually I really doubt if 
> it help with the locking problem you pointed. There are two procedures 
> in miscrev.c - ecryptfs_miscdev_poll() and ecryptfs_miscdev_read() 
> which takes/releases mutexes in a bit strange way... investigating, 
> but this patch is needed anyway.

btw., i didnt do any specific ecryptfs testing - randconfig enabled it 
and it got booted. So if you dont get the warning during 
bootup/module-load, you'll have the same test coverage i did.

	Ingo
