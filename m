Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbYDYJsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbYDYJsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759190AbYDYJsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:48:06 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:62823 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759265AbYDYJsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:48:05 -0400
To: Joerg Friedrich <Joerg.Friedrich@friedrich-kn.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-gitX and pmd_bad() on x86_32
From: Andi Kleen <andi@firstfloor.org>
References: <20080425084007.GC14387@stardust.frews.de>
Date: Fri, 25 Apr 2008 11:48:02 +0200
In-Reply-To: <20080425084007.GC14387@stardust.frews.de> (Joerg Friedrich's message of "Fri, 25 Apr 2008 10:40:07 +0200")
Message-ID: <8763u6xo31.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2008 09:41:11.0785 (UTC) FILETIME=[7F2C1D90:01C8A6B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Friedrich <Joerg.Friedrich@friedrich-kn.de> writes:

> Yesterday I tried to compile 2.6.25-git5 but I ran into a "Unknown
> Symbol" (pmd_bad)  warning from linker while compiling the nvidia-binary module.

pmd_bad is always optional. You can safely make it return 0 in some local
macro.

> AFAICS, x86_32 is the only architecture where pmd_bad is neither a
> define or a static inline. Including asm/pgtable.h is no longer
> sufficient on x868_32. Is this behaviour intended or is there just a
> EXPORT_SYMBOL missing?

Kernel changes generally don't care about out of tree modules.
Also pmd_bad() is kind of internal anyways.

-Andi
