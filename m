Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbXEPSZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbXEPSZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbXEPSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:24:59 -0400
Received: from gw.goop.org ([64.81.55.164]:58145 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943AbXEPSY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:24:58 -0400
Message-ID: <464B4C68.6080804@goop.org>
Date: Wed, 16 May 2007 11:24:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: boot failure under qemu
References: <464ABF7C.1000307@goop.org> <464B2762.7040508@zytor.com> <464B318F.1060309@goop.org> <464B4687.20901@zytor.com>
In-Reply-To: <464B4687.20901@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Okay, I've established that this is a bug in the Qemu kernel loader: the
> Qemu loader puts zero in the loadflags, which is wrong no matter how you
> slice it.
>
> I have checked in a workaround in the git.newsetup tree; the workaround
> is to rely on a compile-time value for load low/load high instead of
> looking at loadflags.
>   

Can you post a patch to try?

    J
