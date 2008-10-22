Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYJVPwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYJVPwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYJVPwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:52:42 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:44744 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYJVPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:52:41 -0400
Date: Wed, 22 Oct 2008 16:52:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Glauber Costa <glommer@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
In-Reply-To: <20081022142312.GC26372@elte.hu>
Message-ID: <alpine.LFD.1.10.0810221643250.24509@ftp.linux-mips.org>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu> <20081022141720.GB9639@localhost> <20081022142312.GC26372@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Ingo Molnar wrote:

> ah, Compaq - how many CPUs does that box support? If it's 8 or more then 
> perhaps they turned off the real local APIC, fudged some chipset glue to 
> emulate APIC functionality and thus were able to use 8 or more of these 
> chips? The built-in lapic would only go up to 4 CPUs. (or maybe even 
> just up to dual, depending on the model)

 Hmm, interesting.  The integrated APIC should support up to 14 CPUs 
(assuming one ID is needed for the I/O APIC).  One cannot preclude silicon 
errata affecting the less common hardware configurations though.  It would 
be interesting to see a full bootstrap log with all the APIC debug 
information enabled.  That would probably clarify matters a bit.

 Note that Compaq would have to come with their own solution about the 
discrete APIC as the 82489DX went out of production many years ago -- ten 
at the very least.  OTOH, they could have stockpiled them back then. ;)  
This is one of the few manufacturers I would actually suspect doing so as 
they always seemed keen on going SMP.  Good to know we can support these 
boxes at all these days.

> This reminds us that all the is-integrated-lapic checks still matter 
> today.

 Quite surprising indeed.

  Maciej
