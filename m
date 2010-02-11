Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0BKGpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 01:45:46 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:49850 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0BKGpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 01:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FZMV582No/GjxtIphE/ZfMaSFPKrwSrdnZt30IjFhxkOEtAAhUVx27HFW4p2v86Sjf
         JchQ8E110Ye9Il4clMECOXQCdichJOj3fxGj4V9ZVpx70v6XPGoDAqQRCygpDooDkRMQ
         +TDWMqEcLNajyjozLSV0RoXo5Py2B4F4i8RA0=
Date: Wed, 10 Feb 2010 22:45:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc7
Message-ID: <20100211064537.GC8252@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. There is a single fix for
reported 2.6.32 regression causing IBM trackpoint device to loose
user-supplied settings upon resume.

Changelog:
---------

Dmitry Torokhov (1):
      Input: psmouse - make sure we don't schedule reconnects after cleanup


Diffstat:
--------

 drivers/input/mouse/psmouse-base.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

-- 
Dmitry

