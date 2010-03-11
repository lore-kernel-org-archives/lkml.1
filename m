Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0CKC7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:59:38 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50962 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab0CKC7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:59:37 -0500
Date: Wed, 10 Mar 2010 18:59:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, elendil@planet.nl, cloos@jhcloos.com
Subject: Re: [PATCH 0/2] v4 kconfig: place git SHA1 in .config output if in
	SCM
Message-ID: <20100311025933.GC6767@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100305194305.GA23009@linux.vnet.ibm.com> <4B951143.1050807@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B951143.1050807@suse.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 04:01:23PM +0100, Michal Marek wrote:
> On 5.3.2010 20:43, Paul E. McKenney wrote:
> > This patch appends the localversion string to the Linux kernel version.
> > For example, in a git tree with uncommitted changes, the .config file
> > might start as follows (but with leading hash marks):
> > 
> > 	Automatically generated make config: don't edit
> > 	Linux kernel version: 2.6.33-01836-g90a6501-dirty
> > 	Mon Mar  1 17:05:59 2010
> > 
> > The "-01836-g90a6501-dirty" string is added by this patch.
> 
> kbuild in linux-next already has
> commit 85a256d8e0116c8f5ad276730830f5d4d473344d
> Author: David Rientjes <rientjes@google.com>
> Date:   Wed Jan 13 13:01:05 2010 -0800
> 
>     kbuild: improve version string logic
> 
> which results in a scripts/setlocalversion call during each build. And
> with CONFIG_LOCALVERSION_AUTO, it stores exactly the string you want in
> include/config/kernel.release. So we could change kconfig to read that
> file instead of building the version string again. To also cover the
> !CONFIG_LOCALVERSION_AUTO case, we can add a
> include/config/kernel.release.full file to hold the full string each time.
> 
> Sorry for jumping in so late in the discussion, I had a bit of backlog
> in mail directed to me and linux-kbuild@vger.kernel.org, let alone LKML ;).

Thank you for the pointer, I will take a look.

							Thanx, Paul
