Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYJLGdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYJLGdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 02:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYJLGdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 02:33:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:59000 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750950AbYJLGdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 02:33:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19LTA15xxxL/DTfCKtZMucTA6oOrH4wOgEziq8L3/
	jphaAQtjqUbmnt
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Evgeniy Polyakov <s0mbre@tservice.net.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
In-Reply-To: <1223791374.7521.59.camel@marge.simson.net>
References: <20081009231759.GA8664@tservice.net.ru>
	 <1223633623.4138.86.camel@marge.simson.net>
	 <20081011131352.GA16908@tservice.net.ru>  <1223735947.8485.33.camel@twins>
	 <1223748830.4598.16.camel@marge.simson.net>
	 <1223791374.7521.59.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 12 Oct 2008 08:33:40 +0200
Message-Id: <1223793220.7736.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6899999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-12 at 08:02 +0200, Mike Galbraith wrote:

> Data:
> 
> read/write requests/sec per client count
>                             1       2       4       8      16      32      64     128     256  
> 2.6.26.6.mysql		 7978	19856	37238	36652	34399	33054	31608	27983	23411
> 2.6.27.mysql		 9618	18329	37128	36504	33590	31846	30719	27685	21299
> 2.6.27.rev.mysql	10944	19544	37349	36582	33793	31744	29161	25719	21026
> 2.6.28.git.mysql	 9518	18031	30418	33571	33330	32797	31353	29139	25793
> 									
> 2.6.26.6.pgsql		14165	27516	53883	53679	51960	49694	44377	35361	32879
> 2.6.27.pgsql		14146	27519	53797	53739	52850	47633	39976	30552	28741
> 2.6.27.rev.pgsql	14168	27561	53973	54043	53150	47900	39906	31987	28034
> 2.6.28.git.pgsql	14404	28318	55124	55010	55002	54890	53745	53519	52215

P.S.  all knobs stock, TSO/GSO off.

