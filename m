Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZGHGvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZGHGvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZGHGu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:50:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:60878 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbZGHGuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gp6bApI2OU/8sdL/eBcPSrjiAsX5H6XH6WRh/e9SKRi5ue58Txzd+rqjwLBR0dePJc
         wFC1sgDKyEwIWz2xbBD6RWQSV6SczunYRiBO648et7JHSSiCNSOHMuDpf/6CrX9ZkvP/
         gGsxI67H88G3PtdnL/LL6pQU5tnbz760+WkpQ=
Date: Tue, 7 Jul 2009 23:50:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.31-rc0
Message-ID: <20090708065046.GA3309@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. It contains a few bugfixes
and also a driver for GPIO-based matrix keyboards that's been cooking
for quite a time.

Changelog:
---------

David Brownell (1):
      Input: dm355evm_keys - fix kconfig symbol names

Dmitry Torokhov (1):
      Input: arrange keyboards alphabetically

Eric Miao (1):
      Input: add support for generic GPIO-based matrix keypad

Jani Nikula (2):
      Input: gpio-keys - revert 'change timer to workqueue'
      Input: gpio-keys - avoid possibility of sleeping in timer function

Ping Cheng (1):
      Input: wacom - add DTF720a support and fix rotation on Intuos3

Saeed Bishara (1):
      Input: gpio_mouse - use standard driver registration method

Thadeu Lima de Souza Cascardo (1):
      Input: mark serio and i8042 as suspended when hibernating too

Yan Li (1):
      Input: i8042 - more reset quirks for MSI Wind-clone netbooks


Diffstat:
--------

 drivers/input/keyboard/Kconfig         |  294 +++++++++++----------
 drivers/input/keyboard/Makefile        |   33 ++--
 drivers/input/keyboard/gpio_keys.c     |   33 ++-
 drivers/input/keyboard/matrix_keypad.c |  453 ++++++++++++++++++++++++++++++++
 drivers/input/mouse/gpio_mouse.c       |   11 +-
 drivers/input/serio/i8042-x86ia64io.h  |   28 ++
 drivers/input/serio/i8042.c            |    7 +-
 drivers/input/serio/serio.c            |    7 +-
 drivers/input/tablet/wacom_wac.c       |    6 +-
 drivers/mfd/dm355evm_msp.c             |    3 +-
 include/linux/input/matrix_keypad.h    |   65 +++++
 11 files changed, 757 insertions(+), 183 deletions(-)
 create mode 100644 drivers/input/keyboard/matrix_keypad.c
 create mode 100644 include/linux/input/matrix_keypad.h

-- 
Dmitry

