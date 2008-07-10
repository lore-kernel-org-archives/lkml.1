Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYGJXC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYGJXC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYGJXCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:02:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51412 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbYGJXCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:02:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, andi@firstfloor.org,
       jbarnes@virtuousgeek.org, steiner@sgi.com, linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<m1prplv71d.fsf@frodo.ebiederm.org> <4876887E.3080204@linux.intel.com>
Date: Thu, 10 Jul 2008 15:54:51 -0700
In-Reply-To: <4876887E.3080204@linux.intel.com> (Arjan van de Ven's message of
	"Thu, 10 Jul 2008 15:09:02 -0700")
Message-ID: <m17ibtgxj8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arjan van de Ven <arjan@linux.intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0130]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> writes:

> in general the purpose of this is to support 256 and more logical threads....
> .... not going to happen on 32 bit

Huh?

Intel is still making new 32bit processors with otherwise modern chipsets
like tolapai so I don't plan to count anything out.  Especially things like
the iommu support for irqs may be interesting.  Further the iommu irq
support is interesting to hypervisors so I would not at all be surprised
to see the code getting reused in that context, and with 32bit kernels.

I'm not asking for anyone to unify code they are not touching but
rather to code things so unification because trivial.  The entire
purpose of having arch/x86.  We have had this discussion and the
viewpoint that we won't add new hardware features to x86_32 and just
put it in maintenance mode lost, because the hardware manufactures
include Intel have not put x86_32 into strictly maintenance mode.

Eric

