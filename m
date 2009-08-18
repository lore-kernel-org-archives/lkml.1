Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZHRXNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZHRXNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZHRXNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:13:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38223 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZHRXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:13:05 -0400
Subject: Re: [ANNOUNCE] 2.6.31-rc6-rt2
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <alpine.LFD.2.00.0908182311250.3361@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	 <1250629478.516.249.camel@lexx>
	 <alpine.LFD.2.00.0908182311250.3361@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Tue, 18 Aug 2009 18:12:58 -0500
Message-Id: <1250637178.516.327.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 23:14 +0200, Thomas Gleixner wrote:
> Will,
> 
> On Tue, 18 Aug 2009, Will Schmidt wrote:
> > 
> > Booting the system seems mostly OK with maxcpus=1, though this INFO
> > message appears on the console.  (This does repeat after a while..) :
> > 
> >  INFO: task irq/16-IPI:3 blocked for more than 120 seconds.
> 
> Hmm. Why is the IPI threaded ? Can you check older (working) RT
> versions whether the IPIs were threaded there as well ?

I don't think it was..   I do not see it with a "ps | grep IPI" on
2.6.29.5-rt22 running on pseries. 



> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

