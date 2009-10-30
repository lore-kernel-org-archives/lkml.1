Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbZJ3RkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbZJ3RkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 13:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932712AbZJ3RkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 13:40:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbZJ3RkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 13:40:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
Date: Fri, 30 Oct 2009 17:39:56 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
References: <4AE63E3D.8030903@us.ibm.com> <200910301013.46923.arnd@arndb.de> <4AEB12F0.9090006@us.ibm.com>
In-Reply-To: <4AEB12F0.9090006@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910301739.57224.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1//Ux0W11VYV0gQfrLYZyx8QnAgmhKxGYf4bIW
 A53tTjHgcjQIlqCIOpg0DwbCBu4wNJiGv3UG0m4CkhhN3ivk+s
 f9Zef58DAd0MFgB1xr1Hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 October 2009 16:23:12 Darren Hart wrote:
> I don't quite follow. There will be a 1:many relationship between 
> mutex:threads, but there should be a 1:1 relationship between 
> threads:env. Since multiple threads can block on one mutex, the above 
> struct wouldn't provide the necessary number of env to set the jmp point 
> for each one.... am I misunderstanding your suggestion?
> 

No, you are totally right with this. My suggestion would not work.

	Arnd <><
