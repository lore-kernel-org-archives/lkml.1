Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbXGTLZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbXGTLZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbXGTLZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:25:32 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46050 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759266AbXGTLZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:25:31 -0400
Message-ID: <384930723.12146@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 20 Jul 2007 19:25:28 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] remove the limit max_sectors_kb imposed on max_readahead_kb
Message-ID: <20070720112528.GC6300@mail.ustc.edu.cn>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Andrew Morton <akpm@osdl.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070720100740.106917381@mail.ustc.edu.cn> <20070720101124.350754890@mail.ustc.edu.cn> <20070720110743.GT11657@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720110743.GT11657@kernel.dk>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 01:07:43PM +0200, Jens Axboe wrote:
> On Fri, Jul 20 2007, Fengguang Wu wrote:
> > Remove the size limit max_sectors_kb imposed on max_readahead_kb.
> > 
> > max_sectors_kb cannot grow larger than max_hw_sectors_kb, which can be
> > rather small for some disk drives.
> 
> Please CC me on core block layer changes, thanks.

OK.

> The patch looks fine though! Your reasoning is a bit odd, though. I
> think the depency between the two is just wrong and ugly, so I agree it
> should go.
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>

Thank you :-)

