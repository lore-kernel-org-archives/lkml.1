Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZCLSfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZCLSfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZCLSfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:35:37 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:50261 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbZCLSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:35:36 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during boot or logon
Date: Thu, 12 Mar 2009 19:35:30 +0100
User-Agent: KMail/1.9.9
Cc: Jan Glauber <jang@linux.vnet.ibm.com>, linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080835.14032.elendil@planet.nl> <1236871686.19544.3.camel@localhost.localdomain> <200903121546.06687.elendil@planet.nl>
In-Reply-To: <200903121546.06687.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121935.32774.elendil@planet.nl>
X-OriginalArrivalTime: 12 Mar 2009 18:35:33.0272 (UTC) FILETIME=[53E88980:01C9A341]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Frans Pop wrote:
> On Thursday 12 March 2009, Jan Glauber wrote:
> > > AFAICT s390 does not have an NMI watchdog. And I have no idea how I
> > > could trigger a sysrq given that I can't login and only have a dumb
> > > console or SSH session to work with anyway.
> >
> > You can try to trigger sysrq by ^-, so to get the task view type:
> > .^-t
>
> Thanks a lot Jan! On a running system that works, so now the only
> question is if it also works when the system is looping. Will try
> later.

Unfortunately it does not work when the system is hung, not even if I try 
it as a "priority" command.

We're still working on my other 2.6.28 regression. I guess the smart thing 
to do is wait and see what comes out of that first, so let's put this one 
on hold for now.

Cheers,
FJP
