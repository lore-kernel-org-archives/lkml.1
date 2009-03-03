Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZCCQjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZCCQjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZCCQjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:39:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52055 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712AbZCCQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:39:31 -0500
Date: Tue, 3 Mar 2009 16:37:22 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oskar Schirmer <os@emlix.com>,
       David Howells <dhowells@redhat.com>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] binfmt_flat: fix data sections alignment
Message-ID: <20090303163722.GB31911@flint.arm.linux.org.uk>
References: <E1LeXY0-0007Fb-KQ@mailer.emlix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LeXY0-0007Fb-KQ@mailer.emlix.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 05:33:13PM +0100, Johannes Weiner wrote:
> From: Oskar Schirmer <os@emlix.com>
> 
> The flat loader uses an architecture's flat_stack_align() to align the
> stack but assumes word-alignment is enough for the data sections.

I think you're missing Greg Ungerer.  Also, Hyok Choi used to look after
ARM uclinux, but vanished mid-merging with mainline.

I've no idea about the flat binfmt, so I won't be acking this change.
Moreover, I don't know who to pass it to in the ARM community to get an
ack.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
