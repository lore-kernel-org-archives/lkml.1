Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbXLYM3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbXLYM3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 07:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbXLYM3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 07:29:04 -0500
Received: from slackadelic.com ([65.196.224.53]:53399 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbXLYM3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 07:29:03 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Tue, 25 Dec 2007 12:28:55 +0000
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712231730.34935.rjw@sisk.pl> <20071225121231.GA31662@elf.ucw.cz>
In-Reply-To: <20071225121231.GA31662@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712251228.57351.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Tuesday 25 December 2007 12:12:31 Pavel Machek wrote:
> > The patch is fine by me, so if anyone has objections, please speak up.
>
> Just.. I have been running with very similar patch for few years... it
> fixes few prototype machines I have here.

I've withdrawn the patch since it doesn't actually fix the issue (turns out 
it's actually a bug in Linux's handling of suspend-to-RAM for ACPI 1.0 and 
2.0 systems).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
