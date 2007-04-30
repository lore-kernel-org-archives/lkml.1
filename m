Return-Path: <linux-kernel-owner+w=401wt.eu-S1946860AbXD3WY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946860AbXD3WY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946861AbXD3WY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:24:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58894 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946860AbXD3WY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:24:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46366B36.70906@s5r6.in-berlin.de>
Date: Tue, 01 May 2007 00:18:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
References: <20061127165138.GA2991@lst.de>	 <20070430040213.BF9901801A4@magilla.sf.frob.com>	 <20070430091121.GC31397@infradead.org>	 <20070430100917.439ebfc8.akpm@linux-foundation.org> <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
In-Reply-To: <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
[...]
> The rationale is to make the operator prominent and thus make
> the structure of a complex multi-line compound conditional expression more
> readable and obvious at first glance itself. For example, consider:
> 
>     if (veryverylengthycondition1 &&
>         smallcond2 &&
>         (conditionnumber3a ||
>         condition3b)) {
>         ...
>     }
> 
> versus
> 
>     if (veryverylengthycondition1
>         && smallcond2
>         && (conditionnumber3a
>             || condition3b)) {
>         ...
>     }
> 
> ?
> 
> Latter wins, doesn't it?

I find the latter more sensible too, even though I used the former
myself until recently (because I didn't knew better).
-- 
Stefan Richter
-=====-=-=== -=-= ----=
http://arcgraph.de/sr/
