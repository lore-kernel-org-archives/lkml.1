Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZKCGk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZKCGk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZKCGkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:40:55 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60291 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbZKCGky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=pziBRA1vydzFiKm27Dqm0H8gDCRghMWhZqTc0nIfvcFHKFQyFrHQNbrcLPWTd+IGCA
         Abo29bqog0ZaBnJTA3uCtGCaFKXipF0xrEa0tsnrAGDGcnATUdTteFUovMI7Sgd7ByWs
         KO9KalLSEpoueKsxd7QbJw8EYfLuKDK+6EC5k=
Date: Mon, 2 Nov 2009 22:40:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc5
Message-ID: <20091103064054.GD3212@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

David Härdeman (1):
      Input: winbond-cir - select LEDS_TRIGGERS

Dmitry Eremin-Solenikov (1):
      Input: gpio-keys - use IRQF_SHARED

Dmitry Torokhov (1):
      Input: i8042 - try to get stable CTR value when initializing

Jamie Lentin (1):
      Input: atkbd - add a quirk for OQO 01+ multimedia keys


Diffstat:
--------

 drivers/input/keyboard/atkbd.c     |   36 ++++++++++++++++++++++++++++++++++++
 drivers/input/keyboard/gpio_keys.c |    1 +
 drivers/input/misc/Kconfig         |    1 +
 drivers/input/serio/i8042.c        |   35 ++++++++++++++++++++++++++++-------
 4 files changed, 66 insertions(+), 7 deletions(-)

-- 
Dmitry

