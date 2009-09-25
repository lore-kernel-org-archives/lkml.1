Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbZIYJxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbZIYJxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIYJxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:53:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZIYJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:53:21 -0400
Subject: Re: ARCH=x86 patch
From: David Woodhouse <dwmw2@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeff Dike <jdike@addtoit.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4ABC8F50.2030006@zytor.com>
References: <4ABC8F50.2030006@zytor.com>
Content-Type: text/plain
Date: Fri, 25 Sep 2009 02:50:46 -0700
Message-Id: <1253872246.4310.1448.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 02:37 -0700, H. Peter Anvin wrote:
> I am confused, because I could have sworn I had tested this combination 
> already, but having applied Jeff's UM fix and then David's ARCH=x86 
> patch on top of that, I now find that all the 32-bit builds crap out 
> when building on a 64-bit platform, due to asm-offsets.c being compiled 
> with -m64 rather than -m32.

Argh.

All this nonsense simply because Ingo objected to my previous patch...
purely on the basis that it made 'make randconfig' actually random.

-- 
dwmw2

