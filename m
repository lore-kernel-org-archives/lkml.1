Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZG0PbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZG0PbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZG0PbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:31:09 -0400
Received: from www.tglx.de ([62.245.132.106]:39250 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZG0PbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:31:08 -0400
Date: Mon, 27 Jul 2009 17:30:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Patch RFC 36/37] fs: Convert bd_mount_sem to mutex
In-Reply-To: <20090727152635.GD31597@infradead.org>
Message-ID: <alpine.LFD.2.00.0907271730260.2936@localhost.localdomain>
References: <20090726081459.455111897@linutronix.de> <20090726081558.081388099@linutronix.de> <20090727152635.GD31597@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Jul 2009, Christoph Hellwig wrote:

> On Sun, Jul 26, 2009 at 08:20:38AM -0000, Thomas Gleixner wrote:
> > bd_mount_sem is used as mutex so make it a mutex.
> 
> Actually we may return to userspace with it held, so the conversion
> is a bad idea.  But I have a patch I need to post to completely get
> rid of it.

That's why it's RFC :)
 
