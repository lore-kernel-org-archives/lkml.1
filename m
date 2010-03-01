Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab0CAIee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:34:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0CAIec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:34:32 -0500
Date: Mon, 1 Mar 2010 09:34:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git
 tree
Message-ID: <20100301083404.GD19395@elte.hu>
References: <20100301042249.GA12289@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301042249.GA12289@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch appends the SHA1 hash of the current git tree to the
> kernel version line, or "[Not git tree]" if run from a non-git tree.
> Uses "git log" to print the hash.
> 
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

>  	fprintf(out, _("#\n"
>  		       "# Automatically generated make config: don't edit\n"
> -		       "# Linux kernel version: %s\n"
> +		       "# Linux kernel version: %s %s\n"
>  		       "%s%s"
>  		       "#\n"),
>  		     sym_get_string_value(sym),
> +		     gitsha[0] == '\0' ? "[Not git tree]" : gitsha,

Very nice!

I have scripting that does something similar for (most of) my own configs, but 
it would be nice to see your more complete patch upstream.

Thanks,

	Ingo
