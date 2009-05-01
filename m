Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbZEAWOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbZEAWOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZEAWOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:14:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:43656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbZEAWOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:14:46 -0400
Date: Sat, 2 May 2009 00:14:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
In-Reply-To: <alpine.LNX.2.00.0904301559140.5012@wotan.suse.de>
Message-ID: <alpine.LNX.2.00.0905020011110.22532@wotan.suse.de>
References: <alpine.LNX.2.00.0904301559140.5012@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Jiri Kosina wrote:

> Linus,
> 
> could you please pull from 'for-linus' branch of
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> 
> to receive fixes for HID code.
> 
> It contains two important fixes (locking fix and possible workqueue 
> deadlock), plus it adds/fixes support of two particular devices (just 
> simple product ID additions/range adjustments).

As this hasn't yet been pulled and I have one more quite important oops 
fix queued since then, I am resending the request with this fix 
incorporated, please consider pulling. Thanks.

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

 drivers/hid/hid-apple.c       |    2 +-
 drivers/hid/hid-core.c        |    4 ++++
 drivers/hid/hid-ids.h         |    1 +
 drivers/hid/hid-lg.c          |    2 ++
 drivers/hid/hidraw.c          |   12 ++++++++----
 drivers/hid/usbhid/hid-core.c |    2 +-
 6 files changed, 17 insertions(+), 6 deletions(-)

Christophe Borivant (1):
      HID: Add support for the G25 force feedback wheel in native mode

Dan Carpenter (1):
      HID: hidraw -- fix missing unlocks in unlocked_ioctl

Jiri Kosina (1):
      HID: fix oops in hid_check_keys_pressed()

Oliver Neukum (1):
      HID: fix possible deadlock in usbhid_close()

Ulrich Dangel (1):
      HID: Fix the support for apple mini aluminium keyboard
