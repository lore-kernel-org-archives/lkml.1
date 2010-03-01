Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab0CAJmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:42:51 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:63062 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab0CAJmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:42:50 -0500
From: Frans Pop <elendil@planet.nl>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git tree
Date: Mon, 1 Mar 2010 10:42:47 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <20100301042249.GA12289@linux.vnet.ibm.com>
In-reply-To: <20100301042249.GA12289@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003011042.48923.elendil@planet.nl>
X-OriginalArrivalTime: 01 Mar 2010 09:42:49.0304 (UTC) FILETIME=[8E219580:01CAB923]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> This patch appends the SHA1 hash of the current git tree to the
> kernel version line, or "[Not git tree]" if run from a non-git tree.
> Uses "git log" to print the hash.

Nice idea.

However, I gave it a try and got:
# Linux kernel version: 2.6.34-rc0 [Not git tree]

Even though I *am* building from a git tree. It does not seem to work when 
building with KBUILD_OUTPUT set or when using 'O='.

IMO that makes the practical value of the patch very limited. I'm afraid 
because of this it will increase confusion rather than add information.

Cheers,
FJP
