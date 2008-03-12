Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYCLWzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYCLWzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYCLWzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:55:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44601 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYCLWzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:55:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: pm_register() and pm_send_all()
Date: Wed, 12 Mar 2008 23:54:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>
References: <20080312150042.96668bcd.akpm@linux-foundation.org>
In-Reply-To: <20080312150042.96668bcd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122354.27484.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of March 2008, Andrew Morton wrote:
> 
> This:
> 
> kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
> kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
> kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
> kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
> 
> is getting a bit boring.  These were marked deprecated at least three years
> ago.
> 
> 
> pm_register() no longer has any callers and afacit can be removed
> immediately.
> 
> pm_send_all() has just a handful of callers:
> 
> arch/x86/kernel/apm_32.c
> arch/mips/au1000/common/power.c
> arch/frv/kernel/pm.c
> 
> could we please get a bit of a push on this?  How should these
> pm_send_all() calls be replaced?

Well, I was going to do that some time ago, but I'm not really familiar with
the old code.  Some assistance would be welcome.

Thanks,
Rafael
