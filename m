Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbYFWTIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbYFWTIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYFWTIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:08:04 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:47524 "EHLO
	mail189-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYFWTIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:08:00 -0400
X-BigFish: VPS-36(z34c9jz1432R98dR7efV1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <485FF408.9030402@am.sony.com>
Date: Mon, 23 Jun 2008 12:05:44 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
References: <1209577322.25560.402.camel@pmac.infradead.org> <1209636171.25560.508.camel@pmac.infradead.org> <20080501104158.GM20451@one.firstfloor.org> <200806231928.09458.vda.linux@googlemail.com> <20080623174537.GB4756@cs181140183.pp.htv.fi>
In-Reply-To: <20080623174537.GB4756@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2008 19:07:45.0070 (UTC) FILETIME=[6B1F04E0:01C8D564]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Jun 23, 2008 at 07:28:09PM +0200, Denys Vlasenko wrote:
>> Had it been a requirement, keeping it in shape wouldn't be
>> too difficult.
>>
>> Sure enough, _now_ fixing kernel to pass such a test on i386
>> would take several weeks of work at least. But it is doable.
>> ...
> 
> On i386 it might even already work today.
> 
> But guess how much time it costs to get at least all defconfigs 
> compiling on the other 22 architectures.
> 
> Even getting allmodconfig/allyesconfig compiling isn't trivial for all 
> architectures, and random configurations are _far_ from compiling.
> 
> And we are not talking about something to be done once, as soon as you 
> leave x86 there are tons of regular breakages.
> 
> Plus the fact that you often get into situations where more options
> mean complex and fragile stuff. Read the Kconfig files under 
> drivers/media/ and check in git all commits to them since 2.6.25 alone, 
> and you'll understand why "add an option for every bit" can result in
> very high ongoing maintainance work required.
> 
> Not everything that is technically possible is also maintainable, and 
> maintainability is a very important point in a project with several 
> million lines changing each year.

OK sure.  Nobody's going to disagree with that.  I would, however,
disagree with a characterization of Linux-tiny as "adding an option
for every bit".  Linux-tiny has been around about 5 years now, and
if you added the whole thing right now you'd add about 30 config
options.

If you're worried about this multiplying out of control, let me
just say that having to curtail the rate of patch submission by
embedded developers has not been our biggest problem.  :-)
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

