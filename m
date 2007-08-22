Return-Path: <linux-kernel-owner+w=401wt.eu-S1763918AbXHVQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763918AbXHVQG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbXHVQGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:06:49 -0400
Received: from gherkin.frus.com ([192.158.254.49]:34137 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763415AbXHVQGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:06:49 -0400
Subject: Re: [BUG?] 2.6.23-rc3 on alpha
In-Reply-To: <Pine.LNX.4.64.0708220906080.9716@anakin> "from Geert Uytterhoeven
 at Aug 22, 2007 09:06:54 am"
To: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 22 Aug 2007 11:06:45 -0500 (CDT)
CC: linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070822160645.65C79DBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Tue, 21 Aug 2007, Bob Tracy wrote:
> > I'm seeing something new and strange with 2.6.23-rc3 that I wasn't
> > seeing in the 2.6.22+ kernels.  I've got the bootlogo code enabled,
> > and at the point during system initialization where the logo
> > disappears, the console switches from tty1 to tty2.  I can switch
> > back to tty1, so other than the unexpected console tty switch, there
> > doesn't seem to be anything "unfortunate" happening.
> > 
> > Any ideas/explanations?  It's completely repeatable.  I don't think
> > it's related to the "aboot" patches :-).
> 
> The kernel doesn't make the logo disappear, the boot scripts (in
> userspace) do that. So I guess they also switch the console from tty1 to
> tty2.

Agreed that a userspace program is triggering the console switch (the
boot logo normally disappears when the VC fonts get loaded), but what
changed to make this happen where it wasn't happening before?  I've
obviously got some more detective work to do, but I had discounted the
possibility of a user space software update being responsible: the
Debian stable series tends not to have many updates...  Hmmm...  I
recently updated libc6 and related packages (locales, tzdata, etc.).
I don't think I'm going to track this down anytime soon, but the first
step would be to determine which init script is involved.

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
