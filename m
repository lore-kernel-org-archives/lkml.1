Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZFYTWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZFYTWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZFYTVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:21:55 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53911 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZFYTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:21:54 -0400
Date: Thu, 25 Jun 2009 21:24:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Bug in arch/x86/include/asm/boot.h [Was: next cleanup report:  "bad" references to CONFIG variables]
Message-ID: <20090625192412.GA15823@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0906251028270.24694@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906251028270.24694@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 10:34:05AM -0400, Robert P. J. Day wrote:
> 
>   here's the next cleanup report that's well underway -- "bad"
> references to CONFIG variables that don't exist in any Kconfig file:
> 
>   http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables
> 
> (currently, only the arch/ and drivers/ directories have been updated
> -- the rest should be done shortly.)
> 
>   in a nutshell, that's a list of references to variables of the form
> CONFIG_*, where there is no such variable defined anywhere in a
> Kconfig file.  some possible reasons for that:
> 
>   1) leftover historical cruft
>   2) simple typo
>   3) someone's added code without adding the Kconfig infrastructure
>      for it (annoyingly, there appears to be quite a lot of that)
>   4) someone likes to name their macros with a "CONFIG_" prefix just
>      to pollute the Kconfig namespace (argh)
> 

Care to send a patch to fix the one in arch/x86/include/asm/boot.h?

> in any event, it's all there (some of it starting to look awfully
> familiar as the years go by).

>  as always, ignore the false positives.
If you continue this then please filter the know false positives.
For once start ignoring defconfigs.

	Sam
