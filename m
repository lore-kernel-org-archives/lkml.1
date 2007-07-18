Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbXGRUYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbXGRUYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXGRUYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:24:25 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:50230 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbXGRUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:24:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18078.30445.899161.509199@stoffel.org>
Date: Wed, 18 Jul 2007 16:24:13 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
In-Reply-To: <Pine.LNX.4.64.0707182024231.5385@fbirervta.pbzchgretzou.qr>
References: <469A8AED.7070207@nerdgrounds.com>
	<p737ioyxwyq.fsf@bingen.suse.de>
	<469E3806.4030804@zytor.com>
	<20070718182021.GA3898@one.firstfloor.org>
	<Pine.LNX.4.64.0707182024231.5385@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Engelhardt <jengelh@computergmbh.de> writes:

Jan> On Jul 18 2007 20:20, Andi Kleen wrote:
>>> 
>>> Well, how big the vmlinux file is matters if it doesn't fit in memory
>>> with enough time to get to the phase where it is dumping the init
>>> sections.  
>> 
>> If you don't have enough memory for a few tens of KB of init sections
>> you're very unlikely to have enough memory for user space.

Jan> If the code was not too hackish, I would not buy that.

Jan> Routers for example can run -- minus the userspace utilities
Jan> required to set things up -- "without" userspace. Maybe someone
Jan> even comes along and writes the network interface setup as __init
Jan> kernel code. If not that, maybe a code generator. I also remember
Jan> someone who posted sort of a "kernel console" patch (same reason
Jan> - to avoid userspace).

So what about the userspace required to make changes to the router's
running configuration?  No router runs without some sort of userspace
or interactive component.  Who puts SNMP into the kernel directly if
they can help it?  

John
