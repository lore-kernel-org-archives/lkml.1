Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbXIEMci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbXIEMci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXIEMca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:32:30 -0400
Received: from gherkin.frus.com ([192.158.254.49]:48675 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbXIEMc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:32:29 -0400
Subject: Re: [BUG?] 2.6.23-rc3 on alpha
In-Reply-To: <Pine.LNX.4.64.0708220906080.9716@anakin> "from Geert Uytterhoeven
 at Aug 22, 2007 09:06:54 am"
To: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 5 Sep 2007 07:32:28 -0500 (CDT)
CC: linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070905123228.A99E2DBA2@gherkin.frus.com>
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

I don't disagree with Geert's statement (the console was switching when
the console fonts got loaded during system initialization), but the
problem no longer exists in 2.6.23-rc5.  Weird.  N.B.: it could have
been fixed in 2.6.23-rc4, but I didn't try that kernel.  In any event,
I'll quit looking for the cause unless the problem recurs :-).

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
