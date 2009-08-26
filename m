Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZHZVP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZHZVP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZHZVP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:15:56 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:50773 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZHZVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:15:56 -0400
Message-ID: <4A95A5EE.90400@nortel.com>
Date: Wed, 26 Aug 2009 15:15:26 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, raziebe@gmail.com, maximlevitsky@gmail.com,
       efault@gmx.de, riel@redhat.com, wiseman@macs.biu.ac.il,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251282598.3514.20.camel@raz>	<alpine.DEB.1.10.0908260943090.9924@gentwo.org>	<1251297910.1791.22.camel@maxim-laptop>	<1251298443.4791.7.camel@raz>	<1251300625.18584.18.camel@twins>	<alpine.DEB.1.10.0908261136590.9933@gentwo.org>	<1251302598.18584.31.camel@twins>	<alpine.DEB.1.10.0908261211340.9933@gentwo.org>	<20090826180407.GA13632@elte.hu>	<alpine.DEB.1.10.0908261509580.9933@gentwo.org>	<20090826193252.GA14721@elte.hu>	<alpine.DEB.1.10.0908261627110.5554@gentwo.org> <20090826135041.e6169d18.akpm@linux-foundation.org>
In-Reply-To: <20090826135041.e6169d18.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2009 21:15:40.0278 (UTC) FILETIME=[5D1D9160:01CA2692]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 02:50 PM, Andrew Morton wrote:

> What problem?
> 
> All I've seen is "I want 100% access to a CPU".  That's not a problem
> statement - it's an implementation.
> 
> What is the problem statement?

I can only speak for myself...

In our case the problem statement was that we had an inherently
single-threaded emulator app that we wanted to push as hard as
absolutely possible.

We gave it as close to a whole cpu as we could using cpu and irq
affinity and we used message queues in shared memory to allow another
cpu to handle I/O.  In our case we still had kernel threads running on
the app cpu, but if we'd had a straightforward way to avoid them we
would have used it.

Chris
