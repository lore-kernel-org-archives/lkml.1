Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYJILf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYJILf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbYJILfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:35:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYJILft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:35:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1223497370.8195.97.camel@brick>
References: <1223497370.8195.97.camel@brick> <1223450773.8195.80.camel@brick> <19824.1223464566@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: FRV/ARM unaligned access question
Date: Thu, 09 Oct 2008 12:35:17 +0100
Message-ID: <3315.1223552117@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Probably smaller as now the le values aren't being byteswapped anymore,
> only the native endianess can use the struct version.  Care to look at
> the kernel size with the following instead?

For some unknown reason, the data segment shrank by four bytes.  The text
segment stayed the same though:

	warthog>size vmlinux
	   text    data     bss     dec     hex filename
	2207804   66584  150189 2424577  24ff01 vmlinux

I would guess that in that kernel almost nothing uses LE unalignment.

The kernel works, so feel free to add my Acked-by to the patch.

David
