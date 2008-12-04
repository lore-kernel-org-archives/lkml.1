Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbYLDTH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbYLDTH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYLDTHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:07:44 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33010 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052AbYLDTHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:07:43 -0500
Date: Thu, 04 Dec 2008 14:07:52 -0500
From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
In-reply-to: <200812041533.00736.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, mingo@redhat.com
Message-id: <20081204190751.GD20982@clouds>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20081202215154.GL29919@clouds> <200812041533.00736.arnd@arndb.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Dec 04, 2008 at 03:32:59PM +0100, Arnd Bergmann wrote:

> Maybe you have stale header files in include/asm-x86/? That sometimes
> happens if you git-checkout -f or git-reset --hard.

Your suggestion led me to the actual problem: the rsync command I was
running to get files to my build machine was missing --delete, which
meant the build machine's tree had all sorts of cruft.

With that change, I can successfully build the latest Linus kernel
without any patches.  Sorry to have wasted everyone's time.

Jody (crawls back under rock)

> 	Arnd <><
