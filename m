Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbXKNOXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbXKNOXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXKNOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:23:29 -0500
Received: from [198.99.130.12] ([198.99.130.12]:42475 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXKNOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:23:28 -0500
Date: Wed, 14 Nov 2007 09:22:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: uml doesn't work on 2.6.24-rc2
Message-ID: <20071114142247.GA5848@c2.user-mode-linux.org>
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 11:35:56AM +0100, Miklos Szeredi wrote:
> Note, this is 32bit UML on 64bit host, to complicate matters.  So I
> think it's not PTRACE_ARCH_PRCTL, but PTRACE_SET_THREAD_AREA.

Oh, that changes things.  In this case, I believe this problem is fixed
by fd181c72a3c202a3986bcee7551c0838265aec2a.

You'll also need f86f9e6d66027bdcdc9b40c06d431ee53ea0d509 for a
separate problem.

> Maybe this is a fallout from the x86 architecture merge?

No, the problems had been there from before the merge - years, in the
case of the second one.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
