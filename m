Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYCEF0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYCEF0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYCEF0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:26:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:39050 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYCEF0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:26:21 -0500
In-Reply-To: <18382.7074.69060.661720@cargo.ozlabs.ibm.com>
References: <1204301097.14759.6.camel@localhost.localdomain> <1204340690.15052.457.camel@pasglop> <18382.7074.69060.661720@cargo.ozlabs.ibm.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <d495403c2b5f700be085c965746cd211@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: benh@kernel.crashing.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] add strncmp to PowerPC
Date: Wed, 5 Mar 2008 06:26:06 +0100
To: Paul Mackerras <paulus@samba.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Do we have any indication that it performs better than the C one ?
>
> I would expect it to, given that the assembler one has two branches in
> the per-byte loop compared to 3 in the C version.

But really, does it matter for strncmp() in the kernel?

Anyway, this asm code has bugs, as do both the current C version in the
kernel, and the code I posted.  We need to do better :-)


Segher

