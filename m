Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYJESsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYJESsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYJESr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:47:57 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35611 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbYJESr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:47:56 -0400
Date: Sun, 5 Oct 2008 20:46:17 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] atmel-mci: updates for 2.6.28
Message-ID: <20081005204617.14868dc4@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Oct 2008 18:46:02.0805 (UTC) FILETIME=[9DDF2650:01C9271A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
>  arch/avr32/boards/atngw100/setup.c      |    7 +-
>  arch/avr32/boards/atstk1000/atstk1002.c |   18 +-
>  arch/avr32/boards/atstk1000/atstk1003.c |   12 +-
>  arch/avr32/boards/atstk1000/atstk1004.c |   12 +-
>  arch/avr32/include/asm/atmel-mci.h      |   32 +-
>  arch/avr32/mach-at32ap/at32ap700x.c     |   90 ++-

Btw, this will conflict with some upcoming pinmux changes in the avr32
code...

If you're happy with this patchset, could you please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/atmel-mci-2.6.28.git master

instead of applying the patches? If you do that, I can pull it into my
avr32 tree as well and fix up any conflicts. I won't do that before
you've pulled it, of course, and it's probably best if no one base any
further work on it until it's accepted because I might have to rebase
it if someone finds any issues during review.

Haavard
