Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbYGOAwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbYGOAwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbYGOAwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:52:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532AbYGOAwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:52:20 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440807141750m937c824kf37c5adf490c8e4a@mail.gmail.com>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
	 <1216081404.27455.97.camel@shinybook.infradead.org>
	 <86802c440807141750m937c824kf37c5adf490c8e4a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 17:52:04 -0700
Message-Id: <1216083125.27455.125.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 17:50 -0700, Yinghai Lu wrote:
>   MK_FW   firmware/tigon/tg3.bin.gen.S
> make[1]: *** No rule to make target `firmware/tigon/tg3.bin', needed
> by `firmware/tigon/tg3.bin.gen.o'.  Stop.
> make: *** [firmware] Error 2

I didn't include the tg3 patch in what I just asked Linus to pull. Are
you working from linux-next?

-- 
dwmw2

