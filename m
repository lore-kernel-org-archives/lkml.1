Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbZASLqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbZASLqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbZASLqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:46:42 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:41371 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbZASLql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:46:41 -0500
Subject: Re: how to fix nand driver build breakage
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Gao, Yunpeng" <yunpeng.gao@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090120132317.B0B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <38D9F46DFF92C54980D2F2C1E8EE31301FC5E7FB@pdsmsx503.ccr.corp.intel.com>
	 <20090120132317.B0B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Jan 2009 12:46:18 +0100
Message-Id: <1232365578.5764.4.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man, 19 01 2009 kl. 13:25 +0900, skrev KOSAKI Motohiro:
> > Hi all,
> > 
> > I have to use 64bit variable in my 2.6.27 kernel NAND driver as below:
> > ---------------------------------------------------------------------------
> > u64 NAND_capacity;
> > unsigned int block_num, block_size;
> > ...
> > block_num = NAND_capacity / block_size;
> > ---------------------------------------------------------------------------
> > but it failed when compiling and reports 'undefined reference to `__udivdi3'.
> > 
> > Does any idea about this? I need to include some special head file or change something in Kconfig?
> > 
> > BTW, the environment is Fedora Core 9, gcc 4.3.0. 
> 
> Couldn't you use do_div()?

Perhaps rather div_u64, but otherwise he should be able to yes.


Simon Holm Thøgersen

