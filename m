Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYLHK1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYLHK1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 05:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYLHK0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 05:26:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42697 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYLHK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 05:26:50 -0500
Message-ID: <493CF65B.30408@jp.fujitsu.com>
Date: Mon, 08 Dec 2008 19:26:35 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Giangiacomo Mariotti <gg.mariotti@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>	 <493AE770.5030507@shaw.ca>	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>	 <493AF2EA.4030601@shaw.ca>	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>	 <493B4242.1040202@shaw.ca>	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>	 <20081207141337.588aede5@infradead.org>	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>	 <493CCFE4.2080802@jp.fujitsu.com> <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com> <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
In-Reply-To: <493CEF38.3060004@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The weird thing is that 301 seconds is quite a long delay for that.
> It should happen  relatively quickly at boot as the CPUs are initialized.

Indeed.

> When it happens consistently at each boot then yes it's likely something
> leaking from the BIOS initialization sequence. Perhaps try a BIOS update?

I'm not sure but is it make sense if SMI causes an error and dropped MCE
exception without clearing error record?

Thanks,
H.Seto

