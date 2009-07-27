Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZG0P0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZG0P0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZG0P0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:26:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZG0P0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:26:36 -0400
Date: Mon, 27 Jul 2009 11:26:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Patch RFC 36/37] fs: Convert bd_mount_sem to mutex
Message-ID: <20090727152635.GD31597@infradead.org>
References: <20090726081459.455111897@linutronix.de> <20090726081558.081388099@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090726081558.081388099@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 08:20:38AM -0000, Thomas Gleixner wrote:
> bd_mount_sem is used as mutex so make it a mutex.

Actually we may return to userspace with it held, so the conversion
is a bad idea.  But I have a patch I need to post to completely get
rid of it.

