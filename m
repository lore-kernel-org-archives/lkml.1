Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbYDAEtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbYDAEtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 00:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYDAEt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 00:49:27 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:47828 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYDAEt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 00:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JKqcXJlOumaj/KCE3Yj/PXweIpzRsrPo5nnkbdPGQ3RmeBe6Dv8soLVAt+GZ7r76kEDTziry1xkbnBB+R0E7youtmomf7E0Ehi6OFO4TCEOv0vorulnV9aFF4q7KEe0/4gTfBaMPyhJpnaKhAa6AZz6yTDlrOfRK+R9ixAvUzOk=
Date: Tue, 1 Apr 2008 00:49:20 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.25-rc7
Message-ID: <20080401044920.GC18041@anvil.corenet.prv>
References: <20080331194610.GA11913@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331194610.GA11913@anvil.corenet.prv>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. This time it has fix for evdev oops
cause by recent changes to device's lifetime rules.

Changelog:
---------

Dmitry Torokhov (1):
      Input: make sure input interfaces pin parent input devices

Helge Deller (1):
      Input: apm-power - fix crash when unloading modules

Samuel Ortiz (1):
      Input: pxa27x - fix keypad KPC macros


Diffstat:
--------

 drivers/input/apm-power.c              |    7 ++-----
 drivers/input/evdev.c                  |    6 ++----
 drivers/input/joydev.c                 |    3 ++-
 drivers/input/keyboard/pxa27x_keypad.c |    6 +++---
 drivers/input/mousedev.c               |    3 ++-
 include/linux/input.h                  |    5 +++--
 6 files changed, 14 insertions(+), 16 deletions(-)


-- 
Dmitry
