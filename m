Return-Path: <linux-kernel-owner+w=401wt.eu-S1763683AbYCDPYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763683AbYCDPYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbYCDPXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:23:54 -0500
Received: from gw.goop.org ([64.81.55.164]:35613 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbYCDPXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:23:54 -0500
Message-ID: <47CD6858.9070603@goop.org>
Date: Tue, 04 Mar 2008 07:18:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
References: <47C22568.1010405@zytor.com>	 <1203958478.20033.1239002461@webmail.messagingengine.com>	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>	 <20080228131341.GA25213@mailshack.com>	 <1204232996.28798.8.camel@cthulhu.hellion.org.uk>	 <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>	 <1204310323.24514.1239870063@webmail.messagingengine.com>	 <1204322819.6299.1.camel@muff>  <20080301160911.GA13271@mailshack.com> <1204631082.16613.7.camel@muff>
In-Reply-To: <1204631082.16613.7.camel@muff>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> This is a bit magic, is it worth splitting it out as something like
> is_paravirt_environment() ?
>   

Yes, is_paravirt() already exists for this purpose.

The code looking at the boot params will only work if we actually booted 
via the paravirt Linux boot protocol, which Xen doesn't at present.

    J
