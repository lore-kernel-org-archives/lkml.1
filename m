Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbXHVKDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbXHVKDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXHVKDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:03:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:55152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbXHVKDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:03:05 -0400
To: "lode leroy" <lode_leroy@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memchr (trivial) optimization
References: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Aug 2007 12:56:57 +0200
In-Reply-To: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl>
Message-ID: <p73bqczzvk6.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"lode leroy" <lode_leroy@hotmail.com> writes:

> While profiling something completely unrelated, I noticed
> that on the workloads I used memchr for, I saw a 30%-40% improvement
> in performance, with the following trivial changes...
> (basically, it saves 3 operations for each call)

What kind of workload? I didn't think anything in tree
was memchr intensive.

-Andi
