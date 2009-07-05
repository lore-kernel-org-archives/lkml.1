Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZGEQcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZGEQcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZGEQcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:32:22 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:55961 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZGEQcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:32:22 -0400
Date: Sun, 5 Jul 2009 17:38:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
In-Reply-To: <20090705162044.GC4791@lenovo>
Message-ID: <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org>
References: <20090705162044.GC4791@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009, Cyrill Gorcunov wrote:

> Here is an attempt to bring more consistency for apic
> presence check. I hope I covered all the code flows.
> Though it's RFC. Please review and test if possible.
> 
> 	-- Cyrill
> ---
> Instead of messing with (cpu_has_apic|disable_apic)
> to check if we have apic functional, better to distinguish
> them by logical kind. cpu_has_apic -- to check if we may
> use apic functionality, disable_apic -- to note that
> apic was disabled via command line.

 How do you set cpu_has_apic for systems with discrete local APICs?  The 
CPUID flag is not set in this case.

  Maciej
