Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYAXBG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYAXBG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYAXBGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:06:19 -0500
Received: from gw.goop.org ([64.81.55.164]:41174 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYAXBGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:06:18 -0500
Message-ID: <4797E487.8010108@goop.org>
Date: Wed, 23 Jan 2008 17:06:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       =?ISO-8859-15?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com>	 <1201023401.5643.52.camel@localhost.localdomain>	 <479634A9.1090908@zytor.com>	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu> <1201121530.30671.15.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1201121530.30671.15.camel@cthulhu.hellion.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> FYI, CONFIG_DEBUG_PAGEALLOC+PAE is broken. I'll dig in but it might be
> the weekend before I get a chance (there's a beer festival in town ;-)).
>   

I'm poking around trying to get Xen working again as well; I may end up 
fixing it in passing.

At the moment I've got a problem with early_ioremap's bt_pte[] array 
ending up hanging around in init's pagetable, which Xen is most unhappy 
about.

    J
