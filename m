Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbYCEHBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbYCEHBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbYCEHBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:01:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:43164 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659AbYCEHBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:01:38 -0500
In-Reply-To: <18382.12838.527446.325768@cargo.ozlabs.ibm.com>
References: <1204301097.14759.6.camel@localhost.localdomain> <1204340690.15052.457.camel@pasglop> <18382.7074.69060.661720@cargo.ozlabs.ibm.com> <d495403c2b5f700be085c965746cd211@kernel.crashing.org> <18382.12838.527446.325768@cargo.ozlabs.ibm.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5b485b22fcd97d89ee82f1fa5c1940db@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: benh@kernel.crashing.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] add strncmp to PowerPC
Date: Wed, 5 Mar 2008 08:01:20 +0100
To: Paul Mackerras <paulus@samba.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Anyway, this asm code has bugs, as do both the current C version in 
>> the
>> kernel, and the code I posted.  We need to do better :-)
>
> The only bug I know of in the asm code is the behaviour when the count
> is zero.  Do you know of any other?

No, that's the bug I meant.  Sorry for using such inexact language.


Segher

