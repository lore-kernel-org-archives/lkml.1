Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbYARVLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbYARVLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761986AbYARVL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:11:29 -0500
Received: from mail.suse.de ([195.135.220.2]:34292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761375AbYARVL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:11:28 -0500
To: Chodorenko Michail <misha@one.by>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Celeron Core
From: Andi Kleen <andi@firstfloor.org>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by>
Date: Fri, 18 Jan 2008 22:11:26 +0100
In-Reply-To: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by> (Chodorenko Michail's message of "Fri\, 18 Jan 2008 21\:06\:43 +0200")
Message-ID: <p73prvyalfl.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chodorenko Michail <misha@one.by> writes:

> I have a laptop "Extensa 5220", with the processor Celeron based on 'core'
> technology.
> There is ~ / arch/i386/kernel/cpu/cpufreq/p4-clockmod.c in the kernel
> source code
> but there's no line identification of my CPU for apply freqency change
> need to add a ID line 0х16

Note that driver will likely do clock throttling on your CPU.
Using that is usually a bad idea because it does not actually
safe power. It's only intended to let the CPU cool down in some situations.

-Andi
