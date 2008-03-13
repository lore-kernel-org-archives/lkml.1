Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYCMM2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYCMM2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYCMM2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:28:33 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:38874 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYCMM2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:28:33 -0400
Date: Thu, 13 Mar 2008 12:28:23 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: pm_register() and pm_send_all()
Message-ID: <20080313122823.GA19415@linux-mips.org>
References: <20080312150042.96668bcd.akpm@linux-foundation.org> <20080313092813.GA24027@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313092813.GA24027@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:28:13AM +0100, Pavel Machek wrote:

> AFAICT pm_send_all is a nop when noone uses pm_register...
> 
> Hmm.. can we just force CONFIG_PM_LEGACY=n, and see what happens?
> 
> Or maybe this is better idea? It may break build somewhere, but it
> should be easy to fix... (it builds here, i386 and x86-64).

Looks correct to me, thus ACK.

Spinning that a little further I wonder how useful the rest of the
Alchemy code - which seems to only deal with devices - is.  If at all.
I'm going to check with some Alchemy users if that code actually works or
can be removed.  I think the latter.  Also there is the APM emulation
available which provides similar functionality.

  Ralf
