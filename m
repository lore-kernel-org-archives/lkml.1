Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbYCEFk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbYCEFk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYCEFkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:40:17 -0500
Received: from ozlabs.org ([203.10.76.45]:47470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYCEFkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:40:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18382.12838.527446.325768@cargo.ozlabs.ibm.com>
Date: Wed, 5 Mar 2008 16:39:50 +1100
From: Paul Mackerras <paulus@samba.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: benh@kernel.crashing.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] add strncmp to PowerPC
In-Reply-To: <d495403c2b5f700be085c965746cd211@kernel.crashing.org>
References: <1204301097.14759.6.camel@localhost.localdomain>
	<1204340690.15052.457.camel@pasglop>
	<18382.7074.69060.661720@cargo.ozlabs.ibm.com>
	<d495403c2b5f700be085c965746cd211@kernel.crashing.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool writes:

> Anyway, this asm code has bugs, as do both the current C version in the
> kernel, and the code I posted.  We need to do better :-)

The only bug I know of in the asm code is the behaviour when the count
is zero.  Do you know of any other?

Paul.
