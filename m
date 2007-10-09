Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbXJISOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbXJISOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbXJISOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:14:15 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:32842 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbXJISOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:14:14 -0400
Date: Tue, 9 Oct 2007 14:14:13 -0400
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071009181413.GD4003@csclub.uwaterloo.ca>
References: <4706AD19.4040605@pcburn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4706AD19.4040605@pcburn.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 05:31:05PM -0400, Chris Bergeron wrote:
> I've just installed a multiport serial card released by an outfit called 
> Syba.  This is an 8 port serial-only card with an Octopus style breakout 
> cable.  The main chipset on it is an ITE IT8871F.

Well 8250_pci.c mentions IT8871, so it is probably 8250 style in
interface then.

> I've got two questions on this: Is there a driver I should try force 
> loading on it (and if so, what options to use)?  and is there any useful 
> testing I can do to report back to the LKML on this card?

How many serial ports is your kernel configured to use?

CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4

That is from my Debian system's kernel, and it won't activate more than
4 ports automatically.  It will allow up to 16 to be activated though.
I don't remember what the boot command is to override those values to
make the system look for more ports.

--
Len Sorensen
