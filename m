Return-Path: <linux-kernel-owner+w=401wt.eu-S1423401AbXD3SXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423401AbXD3SXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423519AbXD3SXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:23:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59695 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423401AbXD3SXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:23:22 -0400
Date: Mon, 30 Apr 2007 20:19:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
In-Reply-To: <20070430100917.439ebfc8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704302018520.29151@yvahk01.tjqt.qr>
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com>
 <20070430091121.GC31397@infradead.org> <20070430100917.439ebfc8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 10:09, Andrew Morton wrote:
>
>This is
>
>	if (expr1 &&
>		expr2)
>
>versus
>
>	if (expr1
>		&& expr2)
>
>the former is more common and is, IMO, more readable.
>
>The latter can be handy sometimes to prevent an 80-col overflow in the
>first line.

But reads like you would be trying to put
a \ on the expr2 line before expr2 :-/


Jan
-- 
