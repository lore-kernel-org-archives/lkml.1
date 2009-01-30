Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZA3I7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZA3I7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZA3I71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:59:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZA3I70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:59:26 -0500
Subject: Re: 2.6.29-rc3: page allocation failure
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <a4423d670901300022w1d2fe742kddc94869cce2097d@mail.gmail.com>
References: <a4423d670901300022w1d2fe742kddc94869cce2097d@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 09:59:18 +0100
Message-Id: <1233305958.4495.157.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 11:22 +0300, Alexander Beregalov wrote:
> rtorrent: page allocation failure. order:1, mode:0x4020
> Pid: 2161, comm: rtorrent Not tainted 2.6.29-rc3 #1
> Call Trace:

Unless its a very frequent phenomenon, I'd not worry too much about
this.

GFP_ATOMIC allocations (like the one you had here) can fail at any time,
and !0 order even more so.

