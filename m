Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbXEAOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbXEAOQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbXEAOQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:16:25 -0400
Received: from canuck.infradead.org ([209.217.80.40]:52640 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbXEAOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:16:23 -0400
Subject: Re: condingstyle, was Re: utrace comments
From: David Woodhouse <dwmw2@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705011058330.27246@anakin>
References: <20061127165138.GA2991@lst.de>
	 <20070430040213.BF9901801A4@magilla.sf.frob.com>
	 <20070430091121.GC31397@infradead.org>
	 <20070430100917.439ebfc8.akpm@linux-foundation.org>
	 <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
	 <Pine.LNX.4.64.0705011058330.27246@anakin>
Content-Type: text/plain
Date: Tue, 01 May 2007 15:16:13 +0100
Message-Id: <1178028973.2875.78.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 11:00 +0200, Geert Uytterhoeven wrote:
> 
>         if (veryverylengthycondition1 &&
>             smallcond2 &&
>             (conditionnumber3a ||
>              condition3b)) {
>                 ...
>         }

It's horrid. I'd much rather see

        if (veryverylengthycondition1 &&
            smallcond2 &&
            (conditionnumber3a || condition3b)) {
                ...
        }

Even if that does take it over 80 columns, the 'failure' mode will be
that it gets wrapped round to the beginning of the screen or truncated
at 80 columns -- and for the _majority_ of the time, it doesn't matter.

Unless you're paying particular attention to the logic and debugging the
statement, a 'high-level' view of what's going on is perfectly
sufficient; you don't actually read every character anyway.

-- 
dwmw2

