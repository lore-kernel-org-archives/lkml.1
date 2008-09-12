Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYILLym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYILLym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYILLyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:54:33 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:27621 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYILLyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:54:33 -0400
X-BigFish: VPS-31(zz1432R98dR4015M1805M936fQ873fnzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K72ZQI-01-360-01
Message-ID: <48CA586C.2010104@amd.com>
Date: Fri, 12 Sep 2008 13:54:20 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to microcode_intel.c.
References: <20080728164411.490752571@amd.com>	<20080728164448.492961653@amd.com> <20080907120823.59f8fa47@infradead.org>
In-Reply-To: <20080907120823.59f8fa47@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2008 11:54:20.0762 (UTC) FILETIME=[4ACE43A0:01C914CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,

could you please provide some more information about that issue?

Thanks,
Peter

Arjan van de Ven schrieb:
> On Mon, 28 Jul 2008 18:44:16 +0200
> Peter Oruba <peter.oruba@amd.com> wrote:
> 
>> Signed-off-by: Peter Oruba <peter.oruba@amd.com>
>> ---
>>  arch/x86/kernel/Makefile          |    2 +-
>>  arch/x86/kernel/microcode.c       |  855
> 
> \
> 
> 
> unfortunately this patch breaks userland for me; the Fedora initscripts
> suddenly fail (with a [FAILED] that will alarm users) because of this
> rename.... 
> (well it also fails to update the microcode, and if you load the new
> module name by hand first it still fails in many ways ;-( )
> 
> That is a regression in -tip unfortunately....
> 
> 

