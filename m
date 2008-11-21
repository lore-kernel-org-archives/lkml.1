Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYKUSHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYKUSHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYKUSHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:07:09 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:32860 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYKUSHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:07:07 -0500
Date: Fri, 21 Nov 2008 12:06:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <Pine.LNX.4.64.0811210936580.25354@quilx.com>
Message-ID: <Pine.LNX.4.64.0811211119550.27777@quilx.com>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera>
 <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com>
 <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu>
 <Pine.LNX.4.64.0811210936580.25354@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AIM9 results:
		TCP		UDP
2.6.22		104868.00	489970.03
2.6.28-rc5	110007.00	518640.00
net-next	108207.00	514790.00

net-next looses here for some reason against 2.6.28-rc5. But the numbers
are better than 2.6.22 in any case.




