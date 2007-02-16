Return-Path: <linux-kernel-owner+w=401wt.eu-S1422881AbXBPAdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422881AbXBPAdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422883AbXBPAdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:33:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:57445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422881AbXBPAdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:33:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU =?iso-8859-1?q?profiling=09updated=09patch?=
Date: Fri, 16 Feb 2007 01:33:13 +0100
User-Agent: KMail/1.9.5
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com> <1171570918.31179.36.camel@dyn9047021078.beaverton.ibm.com> <20070215215047.GE1913@linux.vnet.ibm.com>
In-Reply-To: <20070215215047.GE1913@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702160133.14330.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+EG+a2ddSudI5+5JfGgVC8usLDfpSB+WZTTfOC49k2Tm4rE3+SDTl+M5X+2WxloOkxCr2i7M+ynepvpgvXhO8qxaTqTfmXtPySQArXpNzd3g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 22:50, Paul E. McKenney wrote:
> Is this 1.5ms with interrupts disabled?  This time period is problematic
> from a realtime perspective if so -- need to be able to preempt.

No, interrupts should be enabled here. Still, 1.5ms is probably a little
too long without a cond_resched() in case kernel preemption is disabled.

	Arnd <><
