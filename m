Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYJHHgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYJHHgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYJHHf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:35:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51222 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYJHHfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:35:55 -0400
Date: Wed, 8 Oct 2008 08:35:20 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: FRV/ARM unaligned access question
Message-ID: <20081008073519.GA19322@flint.arm.linux.org.uk>
References: <1223450773.8195.80.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223450773.8195.80.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 12:26:13AM -0700, Harvey Harrison wrote:
> I noticed that frv/arm are the only two arches that currently use open-coded
> byteshifting routines for both the cpu endianness and the other endianness
> whereas just about all the other arches use a packed-struct version for the
> cpu-endian and then the byteshifting versions (lifted from arm) for the other
> endianness.

I'm sorry, I think you're mistaken.  I've looked at x86, m68k and
parisc, and they all use assembly for their swab functions in
asm/byteorder.h.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
