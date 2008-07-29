Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYG2BYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYG2BYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYG2BYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:24:10 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:24462 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbYG2BYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:24:09 -0400
Date: Tue, 29 Jul 2008 10:24:03 +0900 (JST)
Message-Id: <20080729.102403.150676958.nemoto@toshiba-tops.co.jp>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 2/3] kgdb, mips: add arch support for the kernel's kgdb
 core
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <488E150F.9050508@windriver.com>
References: <20080725.235233.130241768.anemo@mba.ocn.ne.jp>
	<20080728.230512.132304415.anemo@mba.ocn.ne.jp>
	<488E150F.9050508@windriver.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 13:50:55 -0500, Jason Wessel <jason.wessel@windriver.com> wrote:
> There is no technical reason that frame pointers are required for KGDB
> in the present mainline sources.  This does allow for further
> traceability but it is certainly not a requirement for the use of kgdb.
> If all you want to do is look at frame 0 and inspect memory or set a
> breakpoint and look at some structures kgdb will certainly serve your
> purpose.

Yes.  On MIPS, I can even show backtrace without FRAME_POINTER (if I
enabled DEBUG_INFO).

> I'll consider this a defect to the kgdb core and update the
> documentation to reflect that it is advised to use frame pointers, but
> not a requirement.

Thanks, your patch is fine for me.

---
Atsushi Nemoto
