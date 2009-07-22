Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZGVJJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZGVJJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZGVJJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:09:54 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:55365 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbZGVJJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=vIvNTgGvjv6JpC3xC6grjw/NzY3URXLG7Sy4YHjPMHJOBt9OUvHhne944EJIgAQwvG
         CLebw/TnpFKyX0hzzHDUKXKTPIjgOBnXPGzZJ2wxHGLxhTTpSdz7J1gKZRdDh0xoWlKR
         GXX4/CtjqKkACu1+fvsHg2H5Q02QpEp6bnd+0=
From: Ahmed Ammar <b33fc0d3@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Ahmed Ammar <aammar@edge-techno.com>
Subject: [PATCH 0/1] [ARM] ep93xx clockevent support for 2.6.29.6-rt23
Date: Wed, 22 Jul 2009 12:09:45 +0300
Message-Id: <1248253786-18993-1-git-send-email-b33fc0d3@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed Ammar <aammar@edge-techno.com>

I have forward ported some patches that used to exist in the 2.6.24.X-rt which implemented clockevents for the ep93xx platform. I do not know why this was never merged, but I could not find any reasons in the mailing lists.

Implemented sched_clock as other platforms do as ftrace was not working but I am not sure if this still needs for code to ensure everything is using the high resolution timers.

Tested on a TS7200.

Ahmed Ammar (1):
  [ARM] ep93xx clockevent support

 arch/arm/Kconfig                                |    3 +
 arch/arm/mach-ep93xx/core.c                     |  129 ++++++++++++++++++-----
 arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h |    6 +
 arch/arm/mach-ep93xx/include/mach/timex.h       |    6 +
 4 files changed, 118 insertions(+), 26 deletions(-)

