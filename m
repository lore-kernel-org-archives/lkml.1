Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbXIVSra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbXIVSra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXIVSrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:47:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44576 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXIVSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:47:23 -0400
Date: Sat, 22 Sep 2007 12:46:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: memset as memzero
Message-ID: <20070922124659.741cca42@laptopd505.fenrus.org>
In-Reply-To: <20070922083355.GA7226@cvg>
References: <20070922083355.GA7226@cvg>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007 12:33:55 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Hi list,
> 
> could anyone tell me why there is no official memzero function (or
> macros) in the kernel.

it doesn't add value.... memset with a constant 0 is just as fast
(since the compiler knows it's 0) than any wrapper around it, and the
syntax around it is otherwise the same.


> As I see a lot of  kernel parts calls for it
> (defying own macros as alias to memset). Maybe there is a special
> reason not to do so? Actually my suggestion is to define _one_
> general macros for this.

my suggestion is to nuke all the macros and just use memset().

