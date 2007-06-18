Return-Path: <linux-kernel-owner+w=401wt.eu-S1764663AbXFRSAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764663AbXFRSAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbXFRSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:00:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbXFRSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:00:34 -0400
Message-ID: <4676C838.1020006@zytor.com>
Date: Mon, 18 Jun 2007 11:00:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Michael Kerrisk <mtk-manpages@gmx.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: man-pages-2.57 is released
References: <8x3Cc-1LD-13@gated-at.bofh.it> <E1I0HsK-0000of-5v@be1.lrz>
In-Reply-To: <E1I0HsK-0000of-5v@be1.lrz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> 
> BTW1: linux/arch/i386/kernel/ioport.c still states having 8K of bitmaps to
> be excessive (and implicitely and now wrongly as not being done). Since
> there should only be few processes requiring iopl, the 8K should not be
> excessive. We need a native speaker to change this text, at least not me
> right now.
> 

That text almost certainly dates back to when every process had a bitmap.

Unfortunately, in a case of utter design braindamage, you can't have the
I/O bitmap be more than 2^16 bytes away from the base of the TSS, so
fixing that took a long time.

	-hpa
