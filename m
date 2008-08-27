Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYH0UAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYH0UAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYH0UA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:00:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58528 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYH0UAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:00:25 -0400
Date: Wed, 27 Aug 2008 16:00:24 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jeff Dike <jdike@addtoit.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is SKAS still required for UML
In-Reply-To: <20080827190655.GB12522@c2.user-mode-linux.org>
Message-ID: <alpine.LNX.1.10.0808271551270.1378@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808271251170.1378@fbirervta.pbzchgretzou.qr> <20080827190655.GB12522@c2.user-mode-linux.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-08-27 15:06, Jeff Dike wrote:
>On Wed, Aug 27, 2008 at 12:57:53PM -0400, Jan Engelhardt wrote:
>> 
>> I tried to put this to a test, and actually failed to modify the 
>> UML kernel/memory image from within it. I had a simple kernel module 
>> with 'int val = 2;' and upon loading this, done printk("Val is at %p\n", 
>> &val); to get to know the address. A userspace program inside the UML 
>> then tried to dereference that address and read the value, but that 
>> ended in a segfault. /proc/xxx/maps also does not show the UML kernel 
>> being mapped in any process inside the UML. Note that I was running in 
>> SKAS0 mode, both host and guest are all 64-bit. Is the NX bit of the 
>> 64-bit platform securing things off, or has SKAS3 become sort of 
>> obsolete?
>
>SKAS3 is still a significant performance boost.

In tests of mine, oggenc in SKAS0 mode ran at 95% of native speed, which 
is pretty good.
