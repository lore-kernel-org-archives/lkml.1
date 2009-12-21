Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZLUQ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZLUQ3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZLUQ27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:28:59 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:43139
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZLUQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:28:58 -0500
Date: Mon, 21 Dec 2009 17:28:46 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
 boot
Message-ID: <20091221162846.GA3529@gibson.comsick.at>
References: <20091219233457.GA4288@trillian.comsick.at>
 <20091220084656.GA485@merkur.ravnborg.org>
 <20091220091138.GA1793@trillian.comsick.at>
 <20091220100344.GA6614@merkur.ravnborg.org>
 <4B2E084D.6080105@msgid.tls.msk.ru>
 <20091220141156.GA3744@merkur.ravnborg.org>
 <4B2F8369.2060708@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F8369.2060708@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Dec 09 15:17, Michal Marek wrote:
> > How about moving this functionality to mkpiggy where we are
> > less shell script dependent.
> > 
> > Something like the following.
> > I have only tested it lightly (vmlinux.bin did not differ
> > before/after the patch.
> 
> 
> I think that it's a good idea to move this out of the makefiles. But for
> 2.6.33, I think I prefer the patch from Andreas, provided he signs it
> off and Michael G confirms that it fixes his issue.

Just a quick update from my side. I tried the patch from Andreas and build a kernel
with dash as defaulti shell. I was able to boot the resulting kernel image
without any problems.

Kind regards,
Michael
