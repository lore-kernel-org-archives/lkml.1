Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXDJL43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXDJL43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXDJL43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:56:29 -0400
Received: from mail.musicgenome.com ([212.150.69.147]:60034 "EHLO
	mail.musicgenome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989AbXDJL42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:56:28 -0400
Date: Tue, 10 Apr 2007 14:48:39 +0300
From: Tal Kelrich <tal@musicgenome.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.4] (updated Watchdog wdt83627 (Winbond W83627HF/F/HG/G)
 driver, 2.6 backport
Message-ID: <20070410144839.22d8d7fe@shodan.orpak.com>
In-Reply-To: <20070401172424.5399d64c@shodan.orpak.com>
References: <20070401172424.5399d64c@shodan.orpak.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.6.10; i686-redhat-linux-gnu)
X-Habeas-SWE-1: winter into spring
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Musicgenome-MailScanner-Information: Please contact the ISP for more information
X-Musicgenome-MailScanner: Found to be clean
X-Musicgenome-MailScanner-SpamCheck: not spam, SpamAssassin (score=-5.899,
	required 6, autolearn=not spam, ALL_TRUSTED -3.30, BAYES_00 -2.60)
X-Musicgenome-MailScanner-From: tal@musicgenome.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 17:24:24 +0300
Tal Kelrich <tal@musicgenome.com> wrote:

> (resent due to a combination of mailer stupidity and my own
> I had to mangle Padraig's name to make it stop encoding as
> Quoted-Printable. hope this is palatable. sorry for the resends)
> 
> Hello,
> 
> Tested and working on Kontron JREX-PM.
> fairly straightforward backport of w83627hf_wdt.c from 2.6.20.1
> 
> Changes from 2.6 version
> Default timeout set to 120 seconds
> Nonstandard read only proc interface (/proc/watchdog)
> Always reset timer on driver load
> Changed timeout limit to 255
> Ignores failure to acquire IO port
> 
> Caveats:
> Ignores failure to acquire IO port since it is always taken, there's
> probably a better way around that.
> Releases IO port regardless of having acquired it.
> 

Padraig's name still mangled, sorry (couldn't convince sylpheed-claws)

Changes from previous:
Added text to Configure.help file

-- 
Tal Kelrich
PGP fingerprint: 3EDF FCC5 60BB 4729 AB2F  CAE6 FEC1 9AAC 12B9 AA69
Key Available at: http://www.hasturkun.com/pub.txt
----
We come to bury DOS, not to praise it.
	-- Paul Vojta, vojta@math.berkeley.edu
----
