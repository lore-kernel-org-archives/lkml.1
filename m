Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZCLO2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZCLO2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZCLO1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:27:54 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:58343 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZCLO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:27:53 -0400
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during
	boot or logon
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200903091025.53284.elendil@planet.nl>
References: <200903080835.14032.elendil@planet.nl>
	 <200903090253.34173.elendil@planet.nl> <1236587118.8389.20.camel@laptop>
	 <200903091025.53284.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 15:28:06 +0000
Message-Id: <1236871686.19544.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 10:25 +0100, Frans Pop wrote:
> On Monday 09 March 2009, you wrote:
> > On Mon, 2009-03-09 at 02:53 +0100, Frans Pop wrote:
> > > Follow-up to an issue reported on the linux-s390 list, seen in the
> > > Hercules S/390 emulator.
> > >
> > > On Sunday 08 March 2009, Frans Pop wrote:
> > > > Well, not quite. It does boot successfully and I do get a login
> > > > prompt. I can also login on the console or connect with SSH, but in
> > > > both cases the system again gets into some loop before I actually
> > > > get a shell prompt.
> > >
> > > During the bisection series the system would sometimes enter the loop
> > > during the boot procedure, before I tried to logon. After it enters
> > > the loop one processor just goes racing at 100%.
> >
> > Where? Do you have NMI watchdog output, or even sysrq-t?
> 
> I'm afraid I have no idea.
> 
> AFAICT s390 does not have an NMI watchdog. And I have no idea how I could 
> trigger a sysrq given that I can't login and only have a dumb console or 
> SSH session to work with anyway.

You can try to trigger sysrq by ^-, so to get the task view type: .^-t

Cheers, Jan

> Maybe the people on the linux-s390 list have some suggestions, or even the 
> Hercules developers?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-s390" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

