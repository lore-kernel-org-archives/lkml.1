Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbZEGUcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbZEGUcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZEGUcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:32:42 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60338 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752299AbZEGUcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:32:42 -0400
Date: Thu, 7 May 2009 16:21:45 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <20090507212428.2fbe5cfa@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0905071619290.14051@qirst.com>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop>
 <20090507173608.GC6693@linux.vnet.ibm.com> <1241717904.6311.1558.camel@laptop> <20090507180112.GE6693@linux.vnet.ibm.com> <alpine.DEB.1.10.0905071404390.22107@qirst.com> <20090507205357.1be739e1@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0905071555040.14051@qirst.com>
 <20090507212428.2fbe5cfa@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Alan Cox wrote:

> Given HZ=1 doesn't work, its fairly clear that all you are doing is
> frobbing pointlessly with defaults that have been evolved over about 15
> years because they work.

Are you sure that 1000 HZ default was not developed due to the need to
have sufficient time granulaity for poll and select? In most of the 15
years we did not have high resolution timers.

> Whereas if you make jiffies jiffies() and it reads a timer it puts the
> pain in the right place and you can begin to make actual progress to
> making things work properly.

Good idea. A patch would be appreciated.


