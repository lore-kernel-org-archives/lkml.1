Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZI1TVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZI1TVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZI1TVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:21:13 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:36424 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZI1TVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:21:12 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix vt_compat_ioctl
References: <m2y6nzgcud.fsf@igel.home> <20090928183337.GA10855@suse.de>
X-Yow: YOW!!!  I am having fun!!!
Date: Mon, 28 Sep 2009 21:21:14 +0200
In-Reply-To: <20090928183337.GA10855@suse.de> (Greg KH's message of "Mon, 28
	Sep 2009 11:33:37 -0700")
Message-ID: <m2tyymho45.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Mon, Sep 28, 2009 at 08:10:02PM +0200, Andreas Schwab wrote:
>> Call compat_unimap_ioctl, not do_unimap_ioctl.
>
> That's a nice description of what the patch does, but why do we need to
> do that?

It's a compat ioctl handler, so lets call the compat ioctl handler.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
