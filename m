Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186AbZKITRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbZKITRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 14:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZKITRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 14:17:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZKITRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 14:17:11 -0500
Subject: Re: [patch 1/2] locking: Make inlining decision Kconfig based
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-arch@vger.kernel.org
In-Reply-To: <20091109151428.504477141@linutronix.de>
References: <20091109150033.125758935@linutronix.de>
	 <20091109151428.504477141@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 20:16:56 +0100
Message-ID: <1257794216.4108.372.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 15:21 +0000, Thomas Gleixner wrote:
>  6 files changed, 284 insertions(+), 104 deletions(-)

Bloats the code a bit, and the Kconfig expressions are a pain to look
at, but I guess having a clear and unambiguous CONFIG_ symbol in the end
is a win.

If you fix up that floating hunk in the second patch, I guess I'm ok
with it..

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

