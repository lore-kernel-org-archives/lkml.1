Return-Path: <linux-kernel-owner+w=401wt.eu-S937703AbZAPV0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937703AbZAPV0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764641AbZAPV0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:26:40 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:41282 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764570AbZAPV0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:26:39 -0500
Date: Fri, 16 Jan 2009 21:26:38 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jan Beulich <jbeulich@novell.com>
cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: avoid early crash in disable_local_APIC()
In-Reply-To: <497051E7.76E4.0078.0@novell.com>
Message-ID: <alpine.LFD.1.10.0901162122520.29021@ftp.linux-mips.org>
References: <496DE893.76E4.0078.0@novell.com> <20090115110528.GE16253@elte.hu> <20090115224710.GA1327@elte.hu> <20090115224751.GA1625@elte.hu> <497051E7.76E4.0078.0@novell.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009, Jan Beulich wrote:

> Is this with a config that has X86_IO_APIC off (i.e. one the practical use of
> which I never understood, and hence easily forget to consider)? Otherwise
> I can't see how that could happen.

 A lot of systems have a P6-class CPU which has a local APIC and no I/O 
APIC in the chipset.  My old laptop was an example of one.  It saves some 
memory to have X86_IO_APIC disabled on such systems, while still being 
able to use the local APIC for the NMI watchdog and PeMo.

  Maciej
