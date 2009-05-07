Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZEGSXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZEGSXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762566AbZEGSXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:23:14 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43108 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762057AbZEGSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:23:13 -0400
Date: Thu, 7 May 2009 14:12:15 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <20090507180112.GE6693@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0905071404390.22107@qirst.com>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop>
 <20090507173608.GC6693@linux.vnet.ibm.com> <1241717904.6311.1558.camel@laptop> <20090507180112.GE6693@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get back to the main point: I agree with Alok that the default HZ needs
to be as low as possible. The remaining justification is the load
balancing and possible context switching between multiple tasks contenting
for a processor.

Is it enough if this occurs 100 times per second?

If so then we should change the default in kernel/Kconfig.hz.

