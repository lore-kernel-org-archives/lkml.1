Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbYBIN77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbYBIN77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYBIN7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:59:50 -0500
Received: from www.tglx.de ([62.245.132.106]:52625 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbYBIN7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:59:49 -0500
Date: Sat, 9 Feb 2008 14:59:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Jiri Kosina <jkosina@suse.cz>, Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1202553464.6386.7.camel@popeye>
Message-ID: <alpine.LFD.1.00.0802091255190.3145@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
  <1202381094.6179.0.camel@popeye>  <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>  <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>  <1202396868.6087.8.camel@popeye>  <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de> 
 <1202402704.6087.12.camel@popeye>  <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de>  <1202448975.6538.2.camel@popeye>  <alpine.LFD.1.00.0802091053350.3145@apollo.tec.linutronix.de> <1202553464.6386.7.camel@popeye>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Chris Holvenstot wrote:

> Thomas - 
> 
> Attached is the output I believe you requested (standard boot - ommiting
> the NOHPET directive)
> 
> Unless you want to try something else i will run in this configuration
> today to try and verify that the problem is still with us.
> 
> Thanks for th good wishes - it is going to be a while - I had an open
> heart procedure about two weeks ago and they are not subtle  when they
> split your chest open.
> 
> This is why I said that I would be more than happy to do the bisect
> thing if it comes to that - since I can't go out and chase the ladies I
> might as well do something useful.

That'd be cool.
 
> However, as previously stated I would need a little instruction on how
> to accoomplish this.

Linus gave instructions here:

http://marc.info/?l=linux-kernel&m=118408208816556&w=2

If you have further questions, I'm happy to help.
 
> [    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash
....
> [    0.004000] HPET not available

Ok. That confirms, that we never even try to touch hpet at all. So the
mystery why "nohpet" on the kernel command line makes your problem go
away is yet more mysterious.

Thanks,
	tglx
