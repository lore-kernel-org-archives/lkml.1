Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYDDSSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYDDSSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbYDDSSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:18:22 -0400
Received: from www.tglx.de ([62.245.132.106]:45174 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbYDDSSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:18:22 -0400
Date: Fri, 4 Apr 2008 20:18:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Balaji Rao <balajirrao@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yanko Kaneti <yaneti@declera.com>
Subject: Re: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
In-Reply-To: <200804042102.01555.balajirrao@gmail.com>
Message-ID: <alpine.LFD.1.10.0804042017250.3224@apollo.tec.linutronix.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.KN.1DW9HB@albercik> <alpine.LFD.1.10.0804041531001.3224@apollo.tec.linutronix.de> <200804042102.01555.balajirrao@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Balaji Rao wrote:

> On Friday 04 April 2008 07:03:50 pm Thomas Gleixner wrote:
> > On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> > > The following report is on the current list of known regressions
> > > from 2.6.24.  Please verify if the issue is still present in the
> > > mainline.
> > 
> > Yes, it is. The revert of the patch which caused that is queued for
> > todays push to Linus.
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10382
> > > Subject		: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
> > > Submitter	: Yanko Kaneti <yaneti@declera.com>
> > > Date		: 2008-04-02 10:59 (2 days old)
> > > References	: http://lkml.org/lkml/2008/4/2/210
> > > Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > 		  Balaji Rao <balajirrao@gmail.com>
> > > 
> > > 
> > 
> Hi tglx,
> 
> I think the following commit should also be reverted. 
> 
> commit 37a47db8d7f0f38dac5acf5a13abbc8f401707fa
> Author: Balaji Rao <balajirrao@gmail.com>
> Date:   Wed Jan 30 13:30:03 2008 +0100
> 
>     x86: assign IRQs to HPET timers, fix

Yup, I have both.

Anyway, thanks for the reminder 

	tglx
