Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYINHC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYINHC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 03:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYINHCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 03:02:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:51617 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751339AbYINHCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 03:02:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1966jcqTox6WjyLdRtm+NtlALVEj/USPCOaKiyyFP
	CEty59xHr3hurK
Subject: Re: [Bug #11308] tbench regression on each kernel release from 
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1221373494.4979.1.camel@marge.simson.net>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.mr.ZesyIB@albercik>  <48CAE7A0.8000004@linux-foundation.org>
	 <1221306287.5213.111.camel@marge.simson.net>
	 <1221373494.4979.1.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 14 Sep 2008 09:02:26 +0200
Message-Id: <1221375746.5390.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-14 at 08:24 +0200, Mike Galbraith wrote:
> On Sat, 2008-09-13 at 13:44 +0200, Mike Galbraith wrote:
> 
> > 2.6.27-rc6
> > Throughput 1037.98 MB/sec 4 procs
> > 
> > 16384  87380  1        1       60.00    80293.80
> > 16384  87380  1        1       60.00    80266.60
> > 16384  87380  1        1       60.00    80394.83
> > 16384  87380  1        1       60.01    80397.27
> 
> <snip... sigh>
> 
> goes back to current real .27 config
> 
> Throughput 1022.52 MB/sec 4 procs
> 
> 16384  87380  1        1       60.00    75941.95
> 16384  87380  1        1       60.01    76002.46
> 16384  87380  1        1       60.01    76367.55
> 16384  87380  1        1       60.00    76188.66
> 
> ...
> 
> demodularizes seriously over-configured network
> 
> Throughput 750.175 MB/sec 4 procs
> 
> 16384  87380  1        1       60.00    49270.35
> 16384  87380  1        1       60.01    49233.86
> 16384  87380  1        1       60.00    49265.72
> 16384  87380  1        1       60.00    49227.00
> 
> Very un-good thing to try.  Stupid thing too?

Apparently stupid for netfilter.  Uninteresting to this thread I
suppose, so disregard.

	-Mike

