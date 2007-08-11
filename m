Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbXHKAgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbXHKAgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 20:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbXHKAgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 20:36:10 -0400
Received: from ozlabs.org ([203.10.76.45]:37307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbXHKAgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 20:36:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18109.1138.869633.593502@cargo.ozlabs.ibm.com>
Date: Sat, 11 Aug 2007 10:36:02 +1000
From: Paul Mackerras <paulus@samba.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Implement atomic{,64}_{read,write}() without volatile
In-Reply-To: <11867913303733-git-send-email-segher@kernel.crashing.org>
References: <11867913303733-git-send-email-segher@kernel.crashing.org>
	<d6775e129db48371cdf86e94ddfaa1d15617bb8f.1186773842.git.segher@kernel.crashing.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool writes:

> Instead, use asm() like all other atomic operations already do.
> 
> Also use inline functions instead of macros; this actually
> improves code generation (some code becomes a little smaller,
> probably because of improved alias information -- just a few
> hundred bytes total on a default kernel build, nothing shocking).
> 
> Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>

Looks OK to me.  In the hope that Chris Snook will pick it up and
include it with his other atomic changes:

Acked-by: Paul Mackerras <paulus@samba.org>
