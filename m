Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYCVTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYCVTfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 15:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYCVTfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 15:35:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:36669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751031AbYCVTfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 15:35:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18EpYVb0XUEhZIrUemE3Nm+lgZy8HVYCGKTziBYHU
	iQr7FMDBwZOE07
Subject: Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47E51637.8060102@colorfullife.com>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
	 <1206186832.4545.1.camel@marge.simson.net>
	 <47E51637.8060102@colorfullife.com>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 20:35:04 +0100
Message-Id: <1206214504.4538.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-22 at 15:22 +0100, Manfred Spraul wrote:
> Mike Galbraith wrote:
> > Total: 4691827                                Total: 3942000
> >   
> Thanks. Unfortunately the test was buggy, it bound the tasks to the 
> wrong cpu :-(
> Could you run it again? Actually 1 cpu and 4 cpus are probably enough.

Sure.  (ran as before, hopefully no transcription errors)

2.6.22.18-cfs-v24-smp                         2.6.24.3-smp
Result matrix: (psem)
  Thread   0:  2395778       1:  2395779         Thread   0:  2054990       1:  2054992
Total: 4791557                                Total: 4009069
Result matrix: (pmsg)
  Thread   0:  2317014       1:  2317015         Thread   0:  1959099       1:  1959099
Total: 4634029                                Total: 3918198


Result matrix:
  Thread   0:  2340716       2:  2340716         Thread   0:  1890292       2:  1890293
  Thread   1:  2361052       3:  2361052         Thread   1:  1899031       3:  1899032
Total: 9403536                                 Total: 7578648
Result matrix:
  Thread   0:  1429567       2:  1429567         Thread   0:  1295071       2:  1295071
  Thread   1:  1429267       3:  1429268         Thread   1:  1289253       3:  1289254
Total: 5717669                                 Total: 5168649 


Result matrix:
  Thread   0:  2263039       3:  2263039         Thread   0:  1351208       3:  1351209
  Thread   1:  2265120       4:  2265121         Thread   1:  1351300       4:  1351300
  Thread   2:  2263642       5:  2263642         Thread   2:  1319512       5:  1319512
Total: 13583603                                Total: 8044041
Result matrix:
  Thread   0:   483934       3:   483934         Thread   0:   514766       3:   514767
  Thread   1:   239714       4:   239715         Thread   1:   252764       4:   252765
  Thread   2:   270216       5:   270216         Thread   2:   253216       5:   253217
Total: 1987729                                 Total: 2041495


Result matrix:
  Thread   0:  2260038       4:  2260039         Thread   0:   642235       4:   642236
  Thread   1:  2262748       5:  2262749         Thread   1:   642742       5:   642743
  Thread   2:  2271236       6:  2271237         Thread   2:   640281       6:   640282
  Thread   3:  2257651       7:  2257652         Thread   3:   641931       7:   641931
Total: 18103350                                Total: 5134381
Result matrix:
  Thread   0:   382811       4:   382811         Thread   0:   342297       4:   342297
  Thread   1:   382801       5:   382802         Thread   1:   342309       5:   342310
  Thread   2:   376620       6:   376621         Thread   2:   343857       6:   343857
  Thread   3:   376559       7:   376559         Thread   3:   343836       7:   343836
Total: 3037584                                 Total: 2744599


