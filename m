Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbXGAN2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbXGAN2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 09:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbXGAN15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 09:27:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52902 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbXGAN15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 09:27:57 -0400
Subject: Re: [patch 5/5] Optimize page_mkclean_one
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0707010926130.11148@blonde.wat.veritas.com>
References: <20070629135530.912094590@de.ibm.com>
	 <20070629141528.511942868@de.ibm.com>
	 <Pine.LNX.4.64.0706301448450.13752@blonde.wat.veritas.com>
	 <1183274153.15924.6.camel@localhost>
	 <Pine.LNX.4.64.0707010926130.11148@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Sun, 01 Jul 2007 15:27:48 +0200
Message-Id: <1183296468.5180.10.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-01 at 09:54 +0100, Hugh Dickins wrote:

> But I could easily be overlooking something: Peter will recall.

/me tries to get his brain up to speed after the OLS closing party :-)

I did both pte_dirty and pte_write because I was extra careful. One
_should_ imply the other, but since we'll be clearing both, I thought it
prudent to also check both.

I will have to think on this a little more, but I'm currently of the
opinion that the optimisation is not correct. But I'll have a thorough
look at s390 again when I get home.

