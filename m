Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbZADTKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbZADTKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZADTKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:10:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42525 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZADTKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:10:06 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
From: Andi Kleen <andi@firstfloor.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
	<20090104103104.6fdda9f2@infradead.org>
	<alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
Date: Sun, 04 Jan 2009 20:11:21 +0100
In-Reply-To: <alpine.LFD.2.00.0901041038570.3179@localhost.localdomain> (Linus Torvalds's message of "Sun, 4 Jan 2009 10:54:15 -0800 (PST)")
Message-ID: <87fxjyopie.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> That said, I also wonder if we really even need to autoprobe the 
> interrupts on any modern hardware. Rather than trying to speed up irq 
> probing, maybe we could figure it out some other way..

You'll hate that suggestion, but i8250_pnp should already discover
it fine via ACPI on modern systems. ia64 has done it this way 
forever. 

It probably won't work on really old system, but one could always
use DMI year to distingush (not pretty, but works usually)

-Andi

-- 
ak@linux.intel.com
