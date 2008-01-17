Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYAQS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYAQS16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYAQS1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:27:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:39359 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYAQS1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:27:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=X2EeqGX9/jUauFiDo1oU6z9028q6IzG7McfiG6yX2O75D/QSMgJ1CGZEWj6tsAfRT3Eh0b8SNQ4+SVz+8xN+bu+3+SC+dVP9dH31S8Rz7xlXjP446o3KhJ5OiW/a6AOEWmjWBHCthZ86LzX8l/DXmN0yEJClOK0m4naRnePBXx4=
Date: Thu, 17 Jan 2008 13:27:42 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] Input updates for 2.6.24-rc8
Message-ID: <20080117132644.ZZRA012@mailhub.coreip.homeip.net>
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

to receive more updates for the input subsystem.

Changelog:
---------

Andres Salomon (2):
      Input: psmouse - fix potential memory leak in psmouse_connect()
      Input: psmouse - fix input_dev leak in lifebook driver

Daniel Ritz (1):
      Input: usbtouchscreen - fix buffer overflow, make more egalax work

Dmitry Torokhov (1):
      Input: ALPS - fix sync loss on Acer Aspire 5720ZG

Micah Parrish (1):
      Input: mousedev - handle mice that use absolute coordinates

Diffstat:
--------

 drivers/input/mouse/alps.c                 |    2 +-
 drivers/input/mouse/lifebook.c             |    7 +++-
 drivers/input/mouse/psmouse-base.c         |    2 +
 drivers/input/mousedev.c                   |    9 +++++
 drivers/input/touchscreen/usbtouchscreen.c |   55 +++++++++++++++++-----------
 5 files changed, 51 insertions(+), 24 deletions(-)

-- 
Dmitry
