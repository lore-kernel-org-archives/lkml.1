Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYHKPgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYHKPgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYHKPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:36:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43304 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYHKPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:36:09 -0400
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <489F015E.9080704@goop.org>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>
	 <200808090029.28286.arnd@arndb.de> <489CD0F9.9060603@cs.columbia.edu>
	 <1218242286.19082.62.camel@nimitz>  <489F015E.9080704@goop.org>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 08:36:04 -0700
Message-Id: <1218468964.5598.3.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-10 at 07:55 -0700, Jeremy Fitzhardinge wrote:
> Struct pt_regs is not ABI, and can (and has) changed on x86.   It's not 
> suitable for a checkpoint structure because it only contains the 
> registers that the kernel trashes, not all usermode registers (on i386, 
> it leaves out %gs, for example).  asm-x86/ptrace-abi.h does define stuff 
> that's fixed in stone; it expresses it in terms of a register array, 
> with constants defining what element is which register.

Thanks for the explanation.

I just want to reduce the coding and maintenance burden here.  Xen must
do this for partition mobility, right?  Does it define all its own
stuff?

-- Dave

