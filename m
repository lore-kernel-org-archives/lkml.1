Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbXIVIzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbXIVIzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 04:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXIVIzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 04:55:16 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33606 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXIVIzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 04:55:14 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 22 Sep 2007 04:48:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: memset as memzero
In-Reply-To: <20070922083355.GA7226@cvg>
Message-ID: <Pine.LNX.4.64.0709220441090.21302@localhost.localdomain>
References: <20070922083355.GA7226@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, Cyrill Gorcunov wrote:

> Hi list,
>
> could anyone tell me why there is no official memzero function (or
> macros) in the kernel. As I see a lot of kernel parts calls for it
> (defying own macros as alias to memset). Maybe there is a special
> reason not to do so? Actually my suggestion is to define _one_
> general macros for this.

i brought up this issue on the KJ list once upon a time:

https://lists.linux-foundation.org/pipermail/kernel-janitors/2007-February/017847.html

and there didn't seem to be much enthusiasm for it.

  however, i am still curious why there isn't more use of the
already-defined "clear_page" macro.  most architectures appear to
define it:

$ grep -r "define.*clear_page" include

but there are still numerous explicit calls to memset() to zero a
chunk of memory that is exactly PAGE_SIZE in size.  just an
observation.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
