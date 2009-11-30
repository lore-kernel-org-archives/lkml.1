Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZK3HRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZK3HRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZK3HRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:17:51 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:61951 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZK3HRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gMa1KYZ+buFK+gpJ+wWUa1bSrszdeWbY4jl3EQZmtINVErw3q8lEwd3kpHxtmd0gc2
         Qrw6xkNdGEW14pLRQ4uNXvvcN7WxFl/NhiVF1pfQ4p9wLkIrcttXRjFlj7aBQG/lzp9U
         e+v7eatW52tVuYJaETYBsnyTpZ7QHkYhMg7uw=
Date: Sun, 29 Nov 2009 23:17:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc8
Message-ID: <20091130071753.GA10295@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. The only change is the way
we build keysyms that are used by braille keyboards. Without this fix
they simply don't work, other keyboards should not be affected.

Changelog:
---------

Samuel Thibault (1):
      Input: keyboard - fix braille keyboard keysym generation


Diffstat:
--------

 drivers/char/keyboard.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Dmitry

