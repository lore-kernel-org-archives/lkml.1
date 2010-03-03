Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab0CCT6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:58:16 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47127 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0CCT6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:58:09 -0500
Date: Wed, 3 Mar 2010 11:58:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Cloos <cloos@jhcloos.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl
Subject: Re: [PATCH] kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100303195804.GE6804@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100303011858.GA17651@linux.vnet.ibm.com> <alpine.LFD.2.00.1003021725170.3616@localhost.localdomain> <20100303021624.GE6786@linux.vnet.ibm.com> <m37hptl3fl.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m37hptl3fl.fsf@lugabout.jhcloos.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 12:28:38PM -0500, James Cloos wrote:
> Doesn't this patch simply duplicate CONFIG_LOCALVERSION_AUTO's
> functionality, now that it calls scripts/setlocalversion?
> 
> I'd still like to get the hash and only elide the dirty check.

Would you be OK with having to set an environment variable to suppress
the dirty check?

							Thanx, Paul
