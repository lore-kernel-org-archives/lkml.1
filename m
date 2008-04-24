Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYDXHY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYDXHY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYDXHYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:24:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40044 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYDXHYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:24:17 -0400
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: gordonfarquharson@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       netdev@vger.kernel.org
In-Reply-To: <20080424.002038.201593352.davem@davemloft.net>
References: <1209016143.9212.910.camel@pmac.infradead.org>
	 <20080423.231055.193687131.davem@davemloft.net>
	 <1209021399.9212.927.camel@pmac.infradead.org>
	 <20080424.002038.201593352.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 08:24:12 +0100
Message-Id: <1209021852.9212.936.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 00:20 -0700, David Miller wrote:
> But won't the request_module() for AF_UNIX spit out that warning too?

Yes. If you build AF_UNIX as a module, it will. Just once though, before
loading it (assuming it's available).

> Actually, I think I need a clarification.  It is the modular loader
> utility in userspace which is trying to open up AF_UNIX sockets,
> right?

Yes. Or probably libc.

-- 
dwmw2

