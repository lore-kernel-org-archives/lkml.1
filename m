Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZAREC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZAREC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZARECr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:02:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55490 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbZARECq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:02:46 -0500
To: John Hughes <john@Calva.COM>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A patch to arch/i386/kernel/irq.c to help get backtraces of (near) stack overflow situations
From: Andi Kleen <andi@firstfloor.org>
References: <49707BA9.1040102@Calva.COM>
Date: Sun, 18 Jan 2009 05:01:59 +0100
In-Reply-To: <49707BA9.1040102@Calva.COM> (John Hughes's message of "Fri, 16 Jan 2009 13:20:57 +0100")
Message-ID: <87k58tdzyg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Hughes <john@Calva.COM> writes:

> Here's a little patch to irq.c to make stack overflow dumps use a
> separate stack.

This has been fixed last year in mainline with 
04b361abfdc522239e3a071f3afdebf5787d9f03

Morale: If you use ancient kernels you miss a lot of bugfixes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
