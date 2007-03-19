Return-Path: <linux-kernel-owner+w=401wt.eu-S966056AbXCSXxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966056AbXCSXxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965291AbXCSXxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:53:33 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34876 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966056AbXCSXxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:53:32 -0400
Date: Mon, 19 Mar 2007 16:53:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
Message-Id: <20070319165329.b5830789.akpm@linux-foundation.org>
In-Reply-To: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 15:37:16 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> This patchset introduces an arch independent framework to handle lists
> of recently used page table pages to replace the existing (ab)use of the
> slab for that purpose.
> 
> 1. Proven code from the IA64 arch.

Has it been proven that quicklists are superior to simply going direct to the
page allocator for these pages?

Would it provide a superior solution if we were to a) stop zeroing out the
pte's when doing a fullmm==1 teardown and b) go direct to the page allocator
for these pages?
