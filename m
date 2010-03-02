Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0CBBU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:20:59 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50034 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0CBBU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:20:56 -0500
Date: Mon, 1 Mar 2010 17:20:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Cloos <cloos@jhcloos.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in
	git tree
Message-ID: <20100302012055.GK6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301042249.GA12289@linux.vnet.ibm.com> <alpine.LFD.2.00.1003010812410.3616@localhost.localdomain> <20100301164800.GC6758@linux.vnet.ibm.com> <m3r5o34vnp.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3r5o34vnp.fsf@lugabout.jhcloos.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 03:46:26PM -0500, James Cloos wrote:
> >>>>> "Paul" == Paul E McKenney <paulmck@linux.vnet.ibm.com> writes:
> 
> Paul> Agreed!  The "-dirty" modifier for the case of changes not yet
> Paul> checked into git looks especially helpful.
> 
> Except that the script calls »git update-index --refresh --unmerged«
> and »git diff-index --name-only HEAD«, both of which are painfully
> slow and resource intensive.
> 
> I'd hate to have that run every time I make a kernel.

Good point...  Should we have an environment variable that controls this
behavior?

							Thanx, Paul
