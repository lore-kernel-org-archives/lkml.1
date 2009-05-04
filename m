Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZEDXGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZEDXGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZEDXGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:06:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbZEDXF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:05:59 -0400
Date: Mon, 4 May 2009 16:04:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: &&/|| typo?
Message-Id: <20090504160421.555dbb67.akpm@linux-foundation.org>
In-Reply-To: <49FCB137.8000003@gmail.com>
References: <49FCB137.8000003@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 May 2009 22:46:47 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> Subject: [PATCH] staging: &&/|| typo?

nit: if/when this driver gets moved out of staging/, it will still have
a commit titled "staging: &&/|| typo?" in its record.

That title will be pretty useless and meaningless for a driver which
isn't in staging!

So I'd suggest that in general, the "staging" information be included
inside [], so it gets tossed away as the patch is applied.

Also, the title is pretty bad in other ways - it doesn't identify what
part of the kernel is being changed.  At least, not with sufficient
specificity.


So a better title would be, say,

	[patch] [staging] wis-sony-tuner.c: fix &&/|| error


