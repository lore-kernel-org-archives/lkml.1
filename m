Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYIAOTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYIAOTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYIAOTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:19:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYIAOTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:19:22 -0400
Date: Mon, 1 Sep 2008 16:22:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Steve VanDeBogart <vandebo-lkml@NerdBox.Net>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, jiayingz@google.com,
       dkegel@google.com
Subject: Re: [PATCH 1/6] base: Valgrind headers and Kconfig
Message-ID: <20080901142219.GH18288@one.firstfloor.org>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291613420.15543@abydos.NerdBox.Net> <87ljycxldb.fsf@basil.nowhere.org> <20080901140618.GA5691@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901140618.GA5691@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 10:06:18AM -0400, Jeff Dike wrote:
> On Mon, Sep 01, 2008 at 11:32:00AM +0200, Andi Kleen wrote:
> > Steve VanDeBogart <vandebo-lkml@NerdBox.Net> writes:
> > > Kconfig option for Valgrind.  Suppression file, for known non-issues.
> > > Valgrind header files (svn 8534) that define the client request
> > > mechanism used to annotate programs plus a couple lines to integrate
> > > with Kconfig.
> > 
> > Couldn't you just get the valgrind.h header from the currently
> > installed valgrind? UML relies on host includes anyways, so
> > I don't see a reason to not do that for valgrind too.
> 
> Kernel code can't get headers from the system, unless you're thinking
>        #include "/usr/include/valgrind.h"
> or something similar.

Some um files at least least include sys/* files which are surely
user space?  If they can include that why not valgrind.h? 


-Andi
