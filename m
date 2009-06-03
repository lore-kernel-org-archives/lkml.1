Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZFCFPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZFCFPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZFCFPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:15:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZFCFPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:15:11 -0400
Message-ID: <4A26072B.8040207@cn.fujitsu.com>
Date: Wed, 03 Jun 2009 13:16:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH mmotm 1/2] memcg: add interface to reset limits
References: <20090603114518.301cef4d.nishimura@mxp.nes.nec.co.jp> <20090603114908.52c3aed5.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090603114908.52c3aed5.nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura wrote:
> Setting mem.limit or memsw.limit to 0 has no meaning
> in actual use(no process can run in such condition).
> 

I wrote a test program that set mem.limit to 0 to test
oom in memcg, and now it is in LTP, though I can modify
it accordingly.

> We don't have interface to reset mem.limit or memsw.limit now,
> so let's reset the mem.limit or memsw.limit to default(unlimited)
> when they are being set to 0.
> 

The idea of having a way to set the limit to unlimited is good,
but how about allow this by writing -1 to mem.limit?


