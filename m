Return-Path: <linux-kernel-owner+w=401wt.eu-S965631AbXHaNxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631AbXHaNxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965290AbXHaNxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:53:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60362 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965285AbXHaNx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:53:29 -0400
Date: Fri, 31 Aug 2007 14:53:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Satyam Sharma <satyam@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Joe Perches <joe@perches.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial - constify sched.h
Message-ID: <20070831135323.GA24509@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Satyam Sharma <satyam@infradead.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1188247231.18004.129.camel@localhost> <20070827213323.GA1759@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0708302120290.24730@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.999.0708310121121.28360@enigma.security.iitk.ac.in> <Pine.LNX.4.64.0708302247070.10266@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708302247070.10266@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 10:55:49PM +0200, Jan Engelhardt wrote:
> "those callers". There was _exactly one_ caller, and that was an out-of-tree
> module. There were not any in-kernel callers before, and it did not generate
> any warning. That is perhaps why no one had constified it before me. This does
> not mean we should wait for a caller to pop up before constifying IMHO.

In this case we should just kill it instead of messing with constness.

