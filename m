Return-Path: <linux-kernel-owner+w=401wt.eu-S1750821AbZHRVPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750821AbZHRVPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZHRVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:15:06 -0400
Received: from www.tglx.de ([62.245.132.106]:36929 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbZHRVPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:15:04 -0400
Date: Tue, 18 Aug 2009 23:14:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc6-rt2
In-Reply-To: <1250629478.516.249.camel@lexx>
Message-ID: <alpine.LFD.2.00.0908182311250.3361@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>  <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>  <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain> 
 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>  <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>  <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>  <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain> 
 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>  <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>  <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>  <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> 
 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>  <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>  <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>  <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> 
 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain> <1250629478.516.249.camel@lexx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Tue, 18 Aug 2009, Will Schmidt wrote:
> 
> Booting the system seems mostly OK with maxcpus=1, though this INFO
> message appears on the console.  (This does repeat after a while..) :
> 
>  INFO: task irq/16-IPI:3 blocked for more than 120 seconds.

Hmm. Why is the IPI threaded ? Can you check older (working) RT
versions whether the IPIs were threaded there as well ?

Thanks,

	tglx
