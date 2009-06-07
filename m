Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZFGKPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZFGKPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZFGKPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:15:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbZFGKPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:15:11 -0400
Subject: Re: [GIT PULL] headers_check fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090606214711.GA4813@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244292857.2473.4.camel@ht.satnam>
	 <20090606130210.GA9343@flint.arm.linux.org.uk>
	 <1244299177.2473.21.camel@ht.satnam>
	 <20090606214711.GA4813@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 15:45:16 +0530
Message-Id: <1244369716.2443.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sat, 2009-06-06 at 22:47 +0100, Russell King wrote:
> Right, below is a patch to unifdef.c which allows it to work out if
> an #if expression always evaluates true or false for symbols which
> are being undefined/always defined.
> 
> The patch is slightly more complicated than I'd hoped because unifdef
> needs to see lines fully evaluated - doing otherwise causes it to
> mark the line as "dirty" and copy it over no matter what.
> 
> What follows this email is the diff of what effect it has on the
> headers copied over - as can be seen, all resulting changes are of
> net benefit.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 

This patch not only solve ARM's hwcap.h but also fixes some other arch
header files.

Great work, thanks.
--
JSR


