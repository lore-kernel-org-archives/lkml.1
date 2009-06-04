Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZFDB7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZFDB7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 21:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZFDB7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 21:59:43 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35278 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZFDB7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 21:59:40 -0400
Date: Thu, 4 Jun 2009 02:59:35 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
       hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Message-ID: <20090604015935.GA30472@shareable.org>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603115611.6bbbaf55.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> The "unclean" term doesn't seem a good fit.  It usually means "has
> in-memory data which needs writing back".  But here you've redefined
> "unclean" to mean "got an IO error" or "detected metadata
> inconsistency", or perhaps "dunno, please run fsck to find out".  This
> all should be spelled out in exacting detail and thought about, please.

I agree.  "unclean" (or "dirty") should be reserved for indicating
that the filesystem has been modified, that is, files written to etc.

Use another term like "fault" or "error"?

-- Jamie
