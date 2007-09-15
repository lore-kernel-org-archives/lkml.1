Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbXIOCEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbXIOCEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 22:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXIOCES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 22:04:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbXIOCES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 22:04:18 -0400
Date: Fri, 14 Sep 2007 19:03:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] [-mm patch]  Add a prefix "VMCOREINFO_" to the
 vmcoreinfo macros.
Message-Id: <20070914190350.011cdadb.akpm@linux-foundation.org>
In-Reply-To: <46E9F942.5070007@mxs.nes.nec.co.jp>
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp>
	<46E9F942.5070007@mxs.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 12:00:18 +0900 "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp> wrote:

> [4/4] Add a prefix "VMCOREINFO_" to the vmcoreinfo macros.
>    Old vmcoreinfo macros were defined as generic names SYMBOL/SIZE/OFFSET
>    /LENGTH/CONFIG, and it is impossible to grep for them. So these names
>    should be changed. This discussion is the following:
>    http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/0415.html

I already had these patches, except for #4.

Your email client is space-stuffing the patches, so I have to do s/^ / /g
to apply them.  Please see
http://mbligh.org/linuxdocs/Email/Clients/Thunderbird and/or the
soon-to-be-merged Documentation/email-clients.txt

I plan on folding all of

add-vmcoreinfo.patch
add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch

into a single patch for upstream.
