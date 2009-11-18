Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbZKRUCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbZKRUCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbZKRUCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:02:13 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:37689 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089AbZKRUCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=CqVHtvsCQn5Iv5cgLcguAwQI49lt95JbJLot/jjDeQURdZg0fAk7jqcq8WQLPWg7OI
         obwkIYk8H+Dm2BYSQEPbOVRVRq5XwbIM0BTSVblNH368esVZ0OHYS4WbqGT507ZcNFI5
         eBOT/t21U7MW8zzcjuN1CrD0Uiv2bzS9rdI/Y=
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 21:02:17 +0100
X-Google-Sender-Auth: e861f92a2c5994a5
Message-ID: <10f740e80911181202l6cca6b41m827f2c51f639d1f0@mail.gmail.com>
Subject: TIF_NOTIFY_RESUME on m68k?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k <linux-m68k@vger.kernel.org>
Cc: uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anyone already looked into TIF_NOTIFY_RESUME support for m68k?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d0420c83f39f79afb82010c2d2cafd150eef651b
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ee18d64c1f632043a02e6f5ba5e045bb26a5465f

These commits broke CONFIG_KEYS=y on m68k, so technically the missing
support is a regression compared to 2.6.31.

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
