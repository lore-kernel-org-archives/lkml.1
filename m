Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXLXAJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXLXAJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXLXAJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:09:45 -0500
Received: from slackadelic.com ([65.196.224.53]:40451 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbXLXAJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:09:44 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Mon, 24 Dec 2007 00:09:40 +0000
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712232320.21182.rjw@sisk.pl> <476EEB6F.7080909@kernel.org>
In-Reply-To: <476EEB6F.7080909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712240009.41764.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 December 2007 23:12:47 H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 23 of December 2007, Linus Torvalds wrote:
> >> On Sun, 23 Dec 2007, Rafael J. Wysocki wrote:
> >>> The patch is fine by me, so if anyone has objections, please speak up.
> >>
> >> There is absolutely *no* way I will apply this in an -rc6 release.
> >>
> This is totally the wrong way to go about it.

Please disregard the patch anyway - my test system was still using the custom 
DSDT - it doesn't fix anything.

Regardless, Linus' patch in question (in combination with Rafael's suspend 
reordering work) still broke suspend, and the port 0x142E write is still the 
offender, so something is still not playing nice - I'm just now at a complete 
loss as to what.

(PNPACPI came to mind as a suspect, but even with that disabled, this board/ 
chipset still wedges on suspend).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
