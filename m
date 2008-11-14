Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbYKNLMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbYKNLMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 06:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYKNLME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 06:12:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:46719 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750942AbYKNLMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 06:12:03 -0500
Date: Fri, 14 Nov 2008 12:12:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Robert Richter <robert.richter@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       oprofile-list@lists.sf.net, Jiri Benc <jbenc@suse.cz>,
       Vilem Marsik <vmarsik@suse.cz>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile [still] doesn't work on 2.6.28-rc4 on certain CPU
In-Reply-To: <20081114100938.GA1664@erda.amd.com>
Message-ID: <alpine.LNX.1.10.0811141208460.19853@jikos.suse.cz>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081114100938.GA1664@erda.amd.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Robert Richter wrote:

> Could you at least test with v2.6.27? 

Oprofile in 2.6.27 doesn't work on this system, as far as I know.

> I could not reproduce it on the hardware I am using.

Yes, it seems to be very system-specific. As I have said in my original 
mail, the machine we are seeing this problem on is

        vendor_id       : AuthenticAMD
        cpu family      : 15
        model           : 47
        model name      : AMD Athlon(tm) 64 Processor 3000+
        stepping        : 0

but on the other hand on the following CPU, the oprofile works with 2.6.27 
and 2.6.28-rc4 without any problems, NMIs are coming flawlessly

        vendor_id       : AuthenticAMD
        cpu family      : 15
        model           : 4
        model name      : AMD Athlon(tm) 64 Processor 3000+
        stepping        : 8


-- 
Jiri Kosina
SUSE Labs
