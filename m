Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbXEIItg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbXEIItg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXEIIt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:49:26 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2100 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXEIIt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:49:26 -0400
Message-ID: <46418B0C.5040205@shadowen.org>
Date: Wed, 09 May 2007 09:49:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.21-mm1 -- x86 verify_cpu.S compile failure
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <464046EC.40301@shadowen.org> <20070508152415.GA16967@one.firstfloor.org>
In-Reply-To: <20070508152415.GA16967@one.firstfloor.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, May 08, 2007 at 10:46:20AM +0100, Andy Whitcroft wrote:
>> We are seeing the following compile error on older x86 installs:
>>
>>   arch/i386/kernel/verify_cpu.S: Assembler messages:
>>   arch/i386/kernel/verify_cpu.S:13: Error: `(%esp)' is
>> 			 not a valid 16 bit base/index expression
>>
>> Seems to come from:
>>
>>   x86_64-mm-i386-verify-cpu
>>
>> Compiler:
>>
>>   gcc version 3.3.4 (Debian 1:3.3.4-3)
> 
> Your compiler must be a brother in spirit of Andrew's vaio.
> 
> Does this patch help? 

Heh, it often feels like they are kin.  I've submitted some tests and
will let you know, but it looks plausable :).

-apw
