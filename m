Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXFMDHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXFMDHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 23:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXFMDHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 23:07:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51952 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753443AbXFMDHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 23:07:37 -0400
Message-ID: <381704016.05840@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 13 Jun 2007 11:07:01 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 4/9] readahead: data structure and routines
Message-ID: <20070613030701.GA6494@mail.ustc.edu.cn>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224818.683288460@mail.ustc.edu.cn> <1181619050.6237.23.camel@localhost.localdomain> <20070612120706.GB9624@mail.ustc.edu.cn> <1181694439.6237.94.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181694439.6237.94.camel@localhost.localdomain>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Wed, Jun 13, 2007 at 10:27:19AM +1000, Rusty Russell wrote:
> On Tue, 2007-06-12 at 20:07 +0800, Fengguang Wu wrote:
> > or preferably:
> > 
> > 	pgoff_t start;                 /* where readahead started */
> >         unsigned long size;            /* # of readahead pages */
> > 	unsigned long async_size;      /* do asynchronous readahead when there are only # of pages ahead */
> > 
> > 	unsigned long async_size_old;  /* TODO: this one is not needed for now */
> > 
> > Any opinions? Thanks.
> 
> These names and comments are really nice.  I think the code will become
> more readable after this, too.

Thank you!

> Did you want me to try to make this patch, or did you want to do it?

I'll make it, after your patch, hehe.

Fengguang

