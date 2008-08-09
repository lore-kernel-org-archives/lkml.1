Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbYHICVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbYHICVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbYHICVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:21:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57731 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYHICVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:21:02 -0400
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <489CF0CE.1000603@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>
	 <200808090029.28286.arnd@arndb.de> <489CD0F9.9060603@cs.columbia.edu>
	 <1218242286.19082.62.camel@nimitz>  <489CF0CE.1000603@cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 19:20:58 -0700
Message-Id: <1218248458.19082.68.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 21:20 -0400, Oren Laadan wrote:
> hehehe .. both; I meant that while it doesn't change per architecture, it
> varies between architectures. So "struct pt_regs" compiled for x86-32 is
> different than that compiled for x86-64. Therefore we can't just dump the
> structure as is and expect that 64 bit would be able to parse the 32 bit.
> In other words, we need an intermediate representation.

Surely we already handle this, though.  Don't we allow a 32-bit app
running on a 64-bit kernel to PTRACE_GETREGS and get the 32-bit version?
A 64-bit app will get the 64-bit version making the same syscall.  It's
all handled in the syscall compatibility code.

-- Dave

