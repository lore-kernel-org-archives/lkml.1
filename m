Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZGBJqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZGBJqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZGBJqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:46:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58248 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZGBJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:46:17 -0400
To: xb <xavier.bru@bull.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Xeon 5500 series support in kernel
From: Andi Kleen <andi@firstfloor.org>
References: <4A4C770F.6000709@bull.net>
Date: Thu, 02 Jul 2009 11:46:16 +0200
In-Reply-To: <4A4C770F.6000709@bull.net> (xb's message of "Thu, 02 Jul 2009 10:59:59 +0200")
Message-ID: <877hyrbeon.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xb <xavier.bru@bull.net> writes:

> I wonder if there are specific kernel configuration parameters that
> allow to optimize performances on the recent Xeon 5500 processors (aka
> Nehalem).

The most important optimization is to use a 64bit kernel with NUMA
support enabled (even if you use 32bit userland)

> In particular, should we set CONFIG_GENERIC_CPU or CONFIG_MCORE2 on
> such processors ?

The kernel doesn't really care about compiler optimizations,
so it shouldn't make any difference. CONFIG_GENERIC_CPU is fine.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
