Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYHPRrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYHPRrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYHPRrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 13:47:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYHPRrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:47:07 -0400
Date: Sat, 16 Aug 2008 10:46:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linuxfoundation.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON sucks
Message-Id: <20080816104658.dcdfb0db.akpm@linux-foundation.org>
In-Reply-To: <20080816100948.GB19926@martell.zuzino.mipt.ru>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 14:09:48 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

>       what this code is supposed to do?
> 
> 	journal = handle->h_transaction->t_journal;
> 	if (!journal_set_features(journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE)) {
> 		J_ASSERT (!"Cannot set revoke feature!");
> 			 ^^^^

lol.  It's been there since I merged ext3 in 2.4.15.  Probably it was
in sct's ext3 patches in the RH kernel.

Don't change it - it might be important!
