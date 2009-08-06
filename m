Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZHFFYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZHFFYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZHFFYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:24:47 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:35487 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZHFFYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:user-agent:message-id;
        b=gprUwjirfLPw7LIedA+8s7g3E2Lx+TyGjuWKCwjGtmTg2ZQxKBSW71KBY38lcVxhr4
         IRqRF6AhzG6OmHYNP09068Rk90mZHA86CPKVpA8lfLO+N+fNck/SsoXN0SMCS+3ScfbP
         6NKc1n101E6HqwBgVM366lPWR1hzAJSTSm5G0=
Date: Wed, 5 Aug 2009 22:24:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.31-rc5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090806052443.E4B24526EA5@mailhub.coreip.homeip.net>
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

Eric Miao (1):
      Input: matrix_keypad - make matrix keymap size dynamic

Jory A. Pratt (1):
      Input: i8042 - add Asus G1S to noloop exception list

TJ (1):
      Input: wistron_btns - support Prestigio Wifi RF kill button


Diffstat:
--------

 drivers/input/keyboard/matrix_keypad.c |   18 +++++++++---------
 drivers/input/misc/wistron_btns.c      |   16 ++++++++++++++++
 drivers/input/serio/i8042-x86ia64io.h  |    8 ++++++++
 include/linux/input/matrix_keypad.h    |   13 +++++++------
 4 files changed, 40 insertions(+), 15 deletions(-)

-- 
Dmitry

