Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYIML54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYIML54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 07:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYIML5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 07:57:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:52875 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751660AbYIML5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 07:57:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18/C/03jYI/C8vyJ0z2SsYpbbEdpd5NyOPFh42t+N
	qrTeOn1HmjfSyk
Subject: Re: [Bug #11308] tbench regression on each kernel release from 
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1221306287.5213.111.camel@marge.simson.net>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.mr.ZesyIB@albercik>  <48CAE7A0.8000004@linux-foundation.org>
	 <1221306287.5213.111.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 13 Sep 2008 13:57:41 +0200
Message-Id: <1221307061.5213.115.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-13 at 13:44 +0200, Mike Galbraith wrote:

> 2.6.23.17-cfs-v24.1  (identical config)
> Throughput 1145.28 MB/sec 4 procs
> 
> 16384  87380  1        1       60.00    90278.55
> 16384  87380  1        1       60.01    90579.31
> 16384  87380  1        1       60.01    89412.14
> 16384  87380  1        1       60.00    90270.97
> 
> 2.6.24.7
> Throughput 1119.28 MB/sec 4 procs
> 
> 16384  87380  1        1       60.00    84092.78
> 16384  87380  1        1       60.00    84120.68
> 16384  87380  1        1       60.00    84076.73
> 16384  87380  1        1       60.00    83995.07

P.S. fwiw, scheduler difference between these two kernels is practically
nill.

