Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbXJaEm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbXJaEm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXJaEmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:42:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbXJaEmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:42:14 -0400
Date: Tue, 30 Oct 2007 21:42:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Stiller <ms@2scale.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22.7 Machine Check Exception
Message-Id: <20071030214205.b55e0688.akpm@linux-foundation.org>
In-Reply-To: <1193308858.3808.2.camel@blackberry>
References: <1193308858.3808.2.camel@blackberry>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 12:40:58 +0200 Michael Stiller <ms@2scale.net> wrote:

> Hi,
> 
> i encountered the following machine check exceptions (and hangs) with
> 2.6.22.7 on an Dual Core-2 Xeon System. It occurs if i try to use the
> PCI-X Intel Gigabit Ethernet card after some minutes:
> 
> CPU 3: Machine Check Exception 0000000000000005
> Bank 0: b200004010000400
> Bank 5: b200121020000400
> 
> or
> 
> CPU 1: Machine Check Exception 0000000000000005
> Bank 0: b200004010000400
> Bank 5: b200121020000400
> 
> What is the cause? How can this be debugged?
> 

I guess it means your hardware is sick.  Presumably those two
numbers were supposed to be the same.

I assume this is the same machine as in your "2.6.22.7 reboots if PCI-X eth
card is used for capture" report?

