Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZFQQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZFQQLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZFQQLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:11:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42243 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZFQQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:11:33 -0400
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>, "'Frans Pop'" <elendil@planet.nl>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
In-Reply-To: <20090617152802.GB6042@elte.hu>
References: <1245247057.3312.2.camel@myhost>
	 <bb33bcf20906170700i4a4ea802yf1da08e9870d6221@mail.gmail.com>
	 <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
	 <20090617152802.GB6042@elte.hu>
Content-Type: text/plain; charset=utf-8
Organization: IBM
Date: Wed, 17 Jun 2009 21:41:02 +0530
Message-Id: <1245255064.6255.0.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 17:28 +0200, Ingo Molnar wrote:
> * Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> 
> > > fix compile warning:
> > > arch/x86/kernel/tsc.c: In function ‘time_cpufreq_notifier’:
> > > arch/x86/kernel/tsc.c:635: warning: ‘dummy’ may be used uninitialized in
> > > this function
> > > 
> > > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > 
> > Hello Figo,
> > 
> > Please refer to the following links on discussion on this issue earlier:
> > http://lkml.org/lkml/2009/5/19/312
> > http://lkml.org/lkml/2009/5/19/301
> > http://lkml.org/lkml/2009/5/20/23
> > 
> > I tried to fix it in some other way.
> 
> Ah, and you fixed in what a superior way: you improved the code in 
> the process :-) This is how warnings should be fixed really.

Thanks Ingo. I would do whenever i find again one.

> 
> Applied.
> 
> We apparently missed it when you sent it in May - generally feel 
> free to re-send patches if you dont see a commit notification within 
> a few days.

My mistake. I did not keep track.

Regards--
Subrata

> 
> Thanks,
> 
> 	Ingo

