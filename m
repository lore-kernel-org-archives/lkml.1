Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXGGUwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXGGUwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXGGUwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:52:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbXGGUwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:52:17 -0400
Date: Sat, 7 Jul 2007 13:51:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>, teigland@redhat.com,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 regression fix] DLM must depend on SYSFS
In-Reply-To: <20070707041402.GE3492@stusta.de>
Message-ID: <alpine.LFD.0.999.0707071350380.31544@woody.linux-foundation.org>
References: <20070707041402.GE3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Jul 2007, Adrian Bunk wrote:
>
> The dependency of DLM on SYSFS got lost in
> commit 6ed7257b46709e87d79ac2b6b819b7e0c9184998 resulting in the 
> following compile error with CONFIG_DLM=y, CONFIG_SYSFS=n:

Hmm. Shouldn't we make that a "select", the way we already do for 
CONFIGFS_FS? 

		Linus
