Return-Path: <linux-kernel-owner+w=401wt.eu-S1030570AbXAYVN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030570AbXAYVN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXAYVN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:13:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:11639 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030570AbXAYVN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fz6AcBytxVMRTPM4W/9wYrWaCqxmHT/v644xl+1zoaO+pVHtW95sK3iElN+4ml4D11v0M9suOflYoba24MCjLkJw7VPpMV9HDlL/M7eE26d/eFlwHo+KBJqNWfDe/7EqMLqzJ8BM773wn0v4UkmhIp2rqLkbpx3GmHZ/Ee5imgU=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: O_DIRECT question
Date: Thu, 25 Jan 2007 22:11:38 +0100
User-Agent: KMail/1.8.2
Cc: Phillip Susi <psusi@cfl.rr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <45B90D19.60106@cfl.rr.com> <45B916F2.4070906@tls.msk.ru>
In-Reply-To: <45B916F2.4070906@tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701252211.39017.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
> Phillip Susi wrote:
> > Denis Vlasenko wrote:
> >> You mean "You can use aio_write" ?
> > 
> > Exactly.  You generally don't use O_DIRECT without aio.  Combining the
> > two is what gives the big win.
> 
> Well, it's not only aio.  Multithreaded I/O also helps alot -- all this,
> say, to utilize a raid array with many spindles.
> 
> But even single-threaded I/O but in large quantities benefits from O_DIRECT
> significantly, and I pointed this out before.

Which shouldn't be true. There is no fundamental reason why
ordinary writes should be slower than O_DIRECT.
--
vda
