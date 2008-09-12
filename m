Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYILOI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYILOI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYILOIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:08:49 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:53615 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbYILOIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:08:49 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2008 10:08:48 EDT
Message-ID: <48CA745B.2070605@debian.org>
Date: Fri, 12 Sep 2008 15:53:31 +0200
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Peter Oruba <peter.oruba@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to microcode_intel.c.
References: <20080728164411.490752571@amd.com>	<20080728164448.492961653@amd.com>	<20080907120823.59f8fa47@infradead.org>	<48CA586C.2010104@amd.com> <20080912063517.783b7f85@infradead.org>
In-Reply-To: <20080912063517.783b7f85@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2008 13:53:34.0989 (UTC) FILETIME=[F30EABD0:01C914DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 12 Sep 2008 13:54:20 +0200
> Peter Oruba <peter.oruba@amd.com> wrote:
> 
>> Arjan,
>>
>> could you please provide some more information about that issue?
> 
> well.. the fedora boot script just plain fails.
> I suspect it manually loads microcode.ko or something if CPUID says
> intel; and this now stops working...

Also Debian manually load the module, and it remove it
after upgrading microcode (no need to have the
driver loaded after boot), so changing the name of
module is not so fortunate, also considering the
long releases cycle of Debian.

I would like to have a single microcode module for the
two drivers: generic kernel need both (thus reduce
overhead); specialized kernel are configured only with
the relevant driver, so no additional overhead.

ciao
	cate

