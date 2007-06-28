Return-Path: <linux-kernel-owner+w=401wt.eu-S1765733AbXF1UKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765733AbXF1UKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763989AbXF1UKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:10:32 -0400
Received: from www.osadl.org ([213.239.205.134]:46032 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762925AbXF1UKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:10:32 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: Mounting MMC card
Date: Thu, 28 Jun 2007 22:10:23 +0200
User-Agent: KMail/1.9.5
Cc: Midhun Agnihotram <agnimidhun@gmail.com>, linux-kernel@vger.kernel.org
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com> <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com> <46840A66.1010901@drzeus.cx>
In-Reply-To: <46840A66.1010901@drzeus.cx>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706282210.23770.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 28 Juni 2007 21:22 schrieb Pierre Ossman:
> Since you use busybox I
> assume the system is too lightweight to run udev.

I run udev on an arm system, it costs you about 200kBytes,
and saves you all the trouble with creating device files.
Note that you don't need any rules files. If you want to write
rules, you can even implement a poor-man's hotplug without HAL.
If you can afford 200k, use udev.

Hans

