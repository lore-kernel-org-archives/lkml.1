Return-Path: <linux-kernel-owner+w=401wt.eu-S1763404AbXEPSAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763404AbXEPSAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbXEPSAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:00:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbXEPSAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:00:46 -0400
Message-ID: <464B4687.20901@zytor.com>
Date: Wed, 16 May 2007 10:59:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: boot failure under qemu
References: <464ABF7C.1000307@goop.org> <464B2762.7040508@zytor.com> <464B318F.1060309@goop.org>
In-Reply-To: <464B318F.1060309@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I've established that this is a bug in the Qemu kernel loader: the
Qemu loader puts zero in the loadflags, which is wrong no matter how you
slice it.

I have checked in a workaround in the git.newsetup tree; the workaround
is to rely on a compile-time value for load low/load high instead of
looking at loadflags.

	-hpa

