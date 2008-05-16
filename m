Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYEPKV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYEPKV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYEPKVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:21:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52970 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYEPKVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:21:16 -0400
Date: Fri, 16 May 2008 12:21:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>
cc: Roland <devzero@web.de>, tvrtko@ursulin.net, pernegger@gmail.com,
       snitzer@gmail.com, zorglub_olsen@hotmail.com,
       renatoyamane@mandic.com.br, linux-kernel@vger.kernel.org
Subject: Re: WD doesn`t use disks with Linux - was Re: Re:Western Digital
 GreenPower drives and Linux
In-Reply-To: <482D5547.4000208@draigBrady.com>
Message-ID: <alpine.LNX.1.10.0805161220280.15590@fbirervta.pbzchgretzou.qr>
References: <003201c8b53c$67ff02d0$6400a8c0@bui.materna.com> <482D5547.4000208@draigBrady.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-16 11:35, Pádraig Brady wrote:
>I wrote a few notes about load cycles here:
>http://www.pixelbeat.org/docs/hard_disk_reliability/
>
>It's bad that the WD GreenPower doesn't support
>`hdparm -B` setting its parameters, but I found I
>didn't need to tweak these anyway.
>
>I just got the distro to write less often to the drive
>with the (rel)atime mount options. With that I got an
>acceptable load cycle rate.

The problem is not how often Linux wakes the head up due to
writes of any sort, but how often the head decides to go
down without our consent.
