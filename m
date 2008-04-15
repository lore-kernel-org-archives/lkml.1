Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYDON6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYDON6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYDON6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:58:14 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:40975 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751795AbYDON6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:58:14 -0400
X-YMail-OSG: HOQ5rJ4VM1kreKPB63vhvC0Aye7uIpYgh9GE1qovwgmCa8PTQi8eNMWNnq7GyQohvyAQmg--
X-Mailer: YahooMailRC/902.40 YahooMailWebService/0.7.185
Date: Tue, 15 Apr 2008 06:58:12 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: User space automounter problems after upgrade to 2.6.25-rc9
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org, am-utils <am-utils@am-utils.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <914095.44950.qm@web32604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: Trond Myklebust <trond.myklebust@fys.uio.no>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: linux-kernel@vger.kernel.org; am-utils <am-utils@am-utils.org>
> Sent: Tuesday, April 15, 2008 2:57:26 PM
> Subject: Re: User space automounter problems after upgrade to 2.6.25-rc9
> 
> 
> On Tue, 2008-04-15 at 04:28 -0700, Martin Knoblauch wrote:
> > Hi,
> > 
> >  after booting a newly built 2.6.25-rc9 kernel, I see the following messages 
> and the user space automounter fails to work. Last good kernel for me is 2.6.24, 
> as -rc9 is my first attempt at 2.6.25. Extremely sorry for being late to the 
> game :-(
> > 
> > [   13.776876] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   14.505079] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> > [   12.688801] Invalid hostname "pid4302@lpsdm60:/soft" in NFS lock request
> > 
> > am-utils version is 6.1.5, config is attached
> 
> Already reported in:
>    http://bugzilla.kernel.org/show_bug.cgi?id=10349
> and
>    https://bugzilla.am-utils.org/show_bug.cgi?id=612
> 
> The problem is due to known bugs in the am-utils mount code (no,
> 'pid4302@lpsdm60:/soft' is not and has never been a valid server
> hostname).
> 

 I always wondered, but never asked :-) Apparently the kernel did never care until recently.

> The workaround should be to turn off locking by adding the 'nolock'
> mount flag.
> 

 Not sure what kind of side effects that will have. Probably better to stay at 2.6.24 and wait for a fix in am-utils.

Cheers

Martin

