Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbZLLFlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbZLLFlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 00:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbZLLFlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 00:41:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60931
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757439AbZLLFlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 00:41:11 -0500
Date: Fri, 11 Dec 2009 21:41:17 -0800 (PST)
Message-Id: <20091211.214117.200029438.davem@davemloft.net>
To: yhlu.kernel@gmail.com
Cc: mingo@elte.hu, sri@us.ibm.com, herbert@gondor.apana.org.au,
       torvalds@linux-foundation.org, sjayaraman@suse.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: nfs broken in net-next? -- now in mainline -- bisected:
 d9f5950f90292f7cc42834338dfd5f44dc4cc4ca
From: David Miller <davem@davemloft.net>
In-Reply-To: <86802c440912112125v4aa72189ifcc2d16ecbf79cc4@mail.gmail.com>
References: <86802c440912112125v4aa72189ifcc2d16ecbf79cc4@mail.gmail.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Fri, 11 Dec 2009 21:25:49 -0800

> [linux-2.6]# git bisect good
> d9f5950f90292f7cc42834338dfd5f44dc4cc4ca is first bad commit
> commit d9f5950f90292f7cc42834338dfd5f44dc4cc4ca
> Author: Sridhar Samudrala <sri@us.ibm.com>
> Date:   Wed Oct 7 12:24:25 2009 +0000
> 
>     net: Make UFO on master device independent of attached devices

Thanks.

If I don't hear anything from Sridhar in a day or two I'll simply
revert that change.
