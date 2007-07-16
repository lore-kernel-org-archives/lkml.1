Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbXGPOo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbXGPOo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760021AbXGPOou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:44:50 -0400
Received: from [212.12.190.105] ([212.12.190.105]:32951 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759812AbXGPOot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:44:49 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Date: Mon, 16 Jul 2007 17:44:48 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161744.48298.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> On Mon, 16 Jul 2007, Ingo Molnar wrote:
> > to sum it up: a nice +19 task (the most commonly used nice level in
> > practice) gets 9.1%, 3.9%, 3.1% of CPU time on the old scheduler,
> > depending on the value of HZ. This is quite inconsistent and illogical.
>
> You're correct that you can find artifacts in the extreme cases, it's
> subjective whether this is a serious problem.
> It's nice that these artifacts are gone, but that still doesn't explain
> why this ratio had to be increase that much from around 1:10 to 1:69.

The ratio is definitely to high, but in addition to having a sane ratio by 
default, it's probably wise to allow this to be user-configureable.


Thanks!

--
Al

