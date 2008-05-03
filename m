Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYECTvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYECTvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYECTvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:51:40 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63438 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751711AbYECTvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:51:39 -0400
Date: Sat, 3 May 2008 20:49:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Thomas Gleixner <tglx@linutronix.de>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <481CA40A.7040906@zytor.com>
Message-ID: <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl>
References: <1209810775.6972.37.camel@localhost>
 <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
 <481CA40A.7040906@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, H. Peter Anvin wrote:

> Intel explicitly documents "all processors with family 6 or F."

 It depends (as usually with Intel) on what document you are looking at.  
Based on my short research, the instruction has been retroactively added
to the list of supported opcodes.  Even my somewhat dated P4 manual does
not list it, never mind its predecessors.  It could have been accidentally
omitted or even buggy in some early members of the P6 family and this
could have been the reason for not documenting it from the beginning (the
case of FFREEP comes to mind).

  Maciej
