Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbYBEWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbYBEWvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYBEWvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:51:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43175 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760557AbYBEWvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:51:05 -0500
Date: Tue, 5 Feb 2008 16:50:58 -0600
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, clameter@sgi.com, mel@csn.ul.ie
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
 works on memoryless node.
Message-Id: <20080205165058.fdb48527.pj@sgi.com>
In-Reply-To: <1202249070.5332.58.camel@localhost>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080202090914.GA27723@one.firstfloor.org>
	<20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1202149243.5028.61.camel@localhost>
	<20080205041755.3411b5cc.pj@sgi.com>
	<alpine.DEB.0.9999.0802051146300.5854@chino.kir.corp.google.com>
	<20080205145141.ae658c12.pj@sgi.com>
	<alpine.DEB.1.00.0802051259090.26206@chino.kir.corp.google.com>
	<20080205153326.5c820dbc.pj@sgi.com>
	<1202249070.5332.58.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> Also, your cpuset/mempolicy work will probably need to undo the
> unconditional masking in contextualize_policy() and/or save the original
> node mask somewhere...

Yeah, something like that ... just a small matter of code.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
