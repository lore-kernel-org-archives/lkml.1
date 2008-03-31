Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYCaTqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYCaTqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYCaTqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:46:16 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:58100 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYCaTqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=WsZll6HBYq0JxBXHU2OMOmvgteVfYDjIodWBjMr4kCXMaJw0ZNEZkyIllJQuFqcCSo7VzlCseiIIP/PWwC5rqTvD1PZ1+PP/CuBwAShnnzdttVXGhkRAWqNU9l9Ps0EOmtN6HFBJEyVegZIQdnTIcVwydvv9pBjMnqQogz7zDBE=
Date: Mon, 31 Mar 2008 15:46:10 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] Input updates for 2.6.25-rc7
Message-ID: <20080331194610.GA11913@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. This does not contain the fix for
evdev crash since it is yet undecided which way we should go with regard to
lifetime rule change.

Changelog:
---------

Helge Deller (1):
      Input: apm-power - fix crash when unloading modules

Samuel Ortiz (1):
      Input: pxa27x - fix keypad KPC macros

Diffstat:
--------

 drivers/input/apm-power.c              |    7 ++-----
 drivers/input/keyboard/pxa27x_keypad.c |    6 +++---
 2 files changed, 5 insertions(+), 8 deletions(-)

-- 
Dmitry
