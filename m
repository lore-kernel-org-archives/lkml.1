Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYGMPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYGMPDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYGMPDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:03:30 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:65327 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYGMPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:03:29 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 00/11] remove CONFIG_KMOD
From: Andi Kleen <andi@firstfloor.org>
References: <20080709082834.942992000@sipsolutions.net>
Date: Sun, 13 Jul 2008 17:03:02 +0200
In-Reply-To: <20080709082834.942992000@sipsolutions.net> (Johannes Berg's message of "Wed, 09 Jul 2008 10:28:34 +0200")
Message-ID: <87zlolzv15.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jul 2008 14:55:36.0275 (UTC) FILETIME=[81EB1A30:01C8E4F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> I've rebased this patch series against -next-20080708 (one conflict
> against ftrace, another against BKL pushdown) and fixed the things
> Adrian Bunk pointed out.

You forgot to say why you want to remove that?
 
I personally like to not set CONFIG_KMOD because the auto loader
tends to load way too many modules. e.g. currently when someone requests
aes on x86 you get three different aes modules (including VIA PadLock
aes and an unoptimized C version), and keeping those around
is just a waste. 

Also if I didn't load a driver I prefer if it's not loaded at all.
This is also useful for power saving for example where it's better
to keep modules not loaded that you don't need and it's hard to
control who accesses the respective devices.

Please keep the option.

Thanks.

-Andi

