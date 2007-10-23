Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbXJWKkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbXJWKkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXJWKk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:40:28 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52670 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751703AbXJWKk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:40:28 -0400
Date: Tue, 23 Oct 2007 12:40:21 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel@avr32linux.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] avr32 updates for 2.6.24, round 2
Message-ID: <20071023124021.4b92b442@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20071023114314.2348d5a0@dhcp-255-175.norway.atmel.com>
References: <20071023114314.2348d5a0@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 11:43:14 +0200
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> Subject: [GIT PULL]

Heh, I knew I forgot something. Sorry about that.

Håvard

> Linus,
> 
> Please pull from
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus
> 
> to receive the following updates. This is mostly about connecting a few
> loose ends that came in through other trees, that is make sure that the
> new drivers can actually be used on avr32.
> 
> Alejandro Martinez Ruiz (1):
>       [AVR32] ARRAY_SIZE() cleanup
> 
> Haavard Skinnemoen (3):
>       [AVR32] Fix a couple of sparse warnings
>       [AVR32] Implement more at32_add_device_foo() functions
>       [AVR32] Implement at32_add_device_cf()
> 
> Hans-Christian Egtvedt (1):
>       [AVR32] Wire up AT73C213 sound driver on ATSTK1000 board
> 
> Kristoffer Nyborg Gregertsen (1):
>       [AVR32] Platform code for pata_at32
> 
>  arch/avr32/boards/atstk1000/atstk1002.c |   58 +++++
>  arch/avr32/mach-at32ap/at32ap7000.c     |  344 +++++++++++++++++++++++++++++++
>  arch/avr32/mach-at32ap/extint.c         |    2 +-
>  arch/avr32/mach-at32ap/pm.h             |    4 +-
>  arch/avr32/mach-at32ap/time-tc.c        |    2 +-
>  include/asm-avr32/arch-at32ap/board.h   |   23 ++
>  6 files changed, 429 insertions(+), 4 deletions(-)
