Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZFCFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZFCFrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZFCFrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:47:16 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43219 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFCFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:47:15 -0400
Date: Wed, 3 Jun 2009 14:43:47 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH mmotm 1/2] memcg: add interface to reset limits
Message-Id: <20090603144347.81ec2ce1.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <4A26072B.8040207@cn.fujitsu.com>
References: <20090603114518.301cef4d.nishimura@mxp.nes.nec.co.jp>
	<20090603114908.52c3aed5.nishimura@mxp.nes.nec.co.jp>
	<4A26072B.8040207@cn.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 13:16:27 +0800, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Daisuke Nishimura wrote:
> > Setting mem.limit or memsw.limit to 0 has no meaning
> > in actual use(no process can run in such condition).
> > 
> 
> I wrote a test program that set mem.limit to 0 to test
> oom in memcg, and now it is in LTP, though I can modify
> it accordingly.
> 
Thank you for your information, there is an acutual user then.

> > We don't have interface to reset mem.limit or memsw.limit now,
> > so let's reset the mem.limit or memsw.limit to default(unlimited)
> > when they are being set to 0.
> > 
> 
> The idea of having a way to set the limit to unlimited is good,
> but how about allow this by writing -1 to mem.limit?
> 
O.K.
I'll try it.


Thanks,
Daisuke Nishimura.
