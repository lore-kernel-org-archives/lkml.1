Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYILUOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYILUOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbYILUOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:14:20 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58272 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbYILUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=t6jdZPyoVS/eph6wF+ramzL79gFluEJAdEEYMbfTUEkPVmsfXkDHTzZwtdlm9aZocG
         gS+twRSkQGvonbUzzWP2tbIISd0pRBPF3yM1BL7aWxIzQP4lyANePSJW1hrplVtTT0Z7
         LCGBKa8bEM1NlHx6qooFAOjYcBZEAVE1u/aS4=
Message-ID: <457e13650809121314k44ba4978xb1413f856f951bfb@mail.gmail.com>
Date: Fri, 12 Sep 2008 23:14:17 +0300
From: "Oleksandr Natalenko" <pfactum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: REGRESSION: Sound's decreasing when headphones are plugged
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I've got a Dell Inspiron 1525 laptop and I've got a sound issue since
the kernel 2.6.26 upgrade.

The sound works fine with the laptop speakers, but when I plug my
headphones the sound is decreasing until there's nothing to hear. The
decrease lasts less than 10 seconds. I use ALSA, KDE4 (but the same is
in clean console) and my sound module is snd_hda_intel.

When I unplug the headphones the sound doesn't come back. Alsamixer
says that the level is on top but I can't hear anything.

The only way to make it work is to restart the computer. Restarting
the alsa daemon doesn't work.

I think that it might come from the new kernel since it used to work
before. It also doesn't work with 2.6.27-rc6-git2, but works with
2.6.25.17.

Also, there's no info in dmesg whet I plug/unplug the headphones,
although I've compiled it with ALSA debug.

Thanks.
