Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZCIJ0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZCIJ0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZCIJZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:25:57 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:64391 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbZCIJZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:25:56 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during boot or logon
Date: Mon, 9 Mar 2009 10:25:51 +0100
User-Agent: KMail/1.9.9
Cc: linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080835.14032.elendil@planet.nl> <200903090253.34173.elendil@planet.nl> <1236587118.8389.20.camel@laptop>
In-Reply-To: <1236587118.8389.20.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903091025.53284.elendil@planet.nl>
X-OriginalArrivalTime: 09 Mar 2009 09:25:54.0170 (UTC) FILETIME=[0B97ADA0:01C9A099]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, you wrote:
> On Mon, 2009-03-09 at 02:53 +0100, Frans Pop wrote:
> > Follow-up to an issue reported on the linux-s390 list, seen in the
> > Hercules S/390 emulator.
> >
> > On Sunday 08 March 2009, Frans Pop wrote:
> > > Well, not quite. It does boot successfully and I do get a login
> > > prompt. I can also login on the console or connect with SSH, but in
> > > both cases the system again gets into some loop before I actually
> > > get a shell prompt.
> >
> > During the bisection series the system would sometimes enter the loop
> > during the boot procedure, before I tried to logon. After it enters
> > the loop one processor just goes racing at 100%.
>
> Where? Do you have NMI watchdog output, or even sysrq-t?

I'm afraid I have no idea.

AFAICT s390 does not have an NMI watchdog. And I have no idea how I could 
trigger a sysrq given that I can't login and only have a dumb console or 
SSH session to work with anyway.

Maybe the people on the linux-s390 list have some suggestions, or even the 
Hercules developers?
