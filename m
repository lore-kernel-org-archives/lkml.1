Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYJZNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYJZNjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYJZNi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:38:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:34827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbYJZNi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:38:58 -0400
Subject: Re: [PATCH] Rename DECLARE_MUTEX to DEFINE_SEMAPHORE
From: Peter Zijlstra <peterz@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081026120609.GA10728@joi>
References: <20081026120609.GA10728@joi>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 26 Oct 2008 14:39:06 +0100
Message-Id: <1225028346.32713.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-26 at 13:06 +0100, Marcin Slusarz wrote:
> DECLARE_MUTEX is doubly misleading name (it actually _defines_ struct
> _semaphore_ initialized to 1) and it can be confused with DEFINE_MUTEX
> (which defines real struct mutex). Rename it.

I'd prefer DEFINE_BINARY_SEM or somesuch

