Return-Path: <linux-kernel-owner+w=401wt.eu-S1946139AbXBIVxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946139AbXBIVxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946143AbXBIVxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:53:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36908 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946139AbXBIVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:53:41 -0500
Subject: Re: -mm merge plans for 2.6.21
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
In-Reply-To: <20070209214944.GA16158@flint.arm.linux.org.uk>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <1171042535.29713.96.camel@pmac.infradead.org>
	 <20070209134516.2367a7aa.akpm@linux-foundation.org>
	 <20070209214944.GA16158@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 21:53:19 +0000
Message-Id: <1171057999.29713.129.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 21:49 +0000, Russell King wrote:
> urgh, new system calls... wonder if they fit in the ARM ABI...  Looks
> fine.

Can you elucidate on _what_ you just checked for?

There was something about alignment of 64-bit arguments to syscalls
which affects MIPS and/or ARM which I can't quite remember-- something
about putting it them arguments in either an even-numbered or
odd-numbered position to make it work nicely. Is that actually written
anywhere, and does anyone bother to check?

-- 
dwmw2

