Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXJAGym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXJAGym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 02:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXJAGye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 02:54:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXJAGyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 02:54:33 -0400
Subject: Re: [patch] MTD: fix cfi_interleave() build errors
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071001050145.GA12925@elte.hu>
References: <20071001045037.GA10564@elte.hu>
	 <20071001050145.GA12925@elte.hu>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 07:54:31 +0100
Message-Id: <1191221671.2905.637.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 07:01 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > FYI, the attached .config fails with the build errors below. Kernel is 
> > latest 2.6.23-git. Found via make randconfig.
> 
> the quick fix below resolves these build failures. (i guess it might be 
> cleaner/safer to solve this via excluding this .config combination via 
> Kconfig rules, but that looks too involved for now.)

This is already fixed in my tree; it just wasn't worth pushing for
2.6.23.

-- 
dwmw2

