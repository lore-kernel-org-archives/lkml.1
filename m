Return-Path: <linux-kernel-owner+w=401wt.eu-S1762888AbXHFRla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762888AbXHFRla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXHFRlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:41:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbXHFRlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:41:22 -0400
Message-ID: <46B75D3B.6080101@zytor.com>
Date: Mon, 06 Aug 2007 10:41:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: linux-kernel@vger.kernel.org, Michael Matz <matz@suse.de>
Subject: Re: [PATCH] remove strict ansi check from __u64 in asm/types.h
References: <20070806172331.GA8102@suse.de>
In-Reply-To: <20070806172331.GA8102@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> 
> Remove the __STRICT_ANSI__ check from the __u64/__s64 declaration on
> 32bit targets.
> 
> Here is the reason why we think the check should be relaxed:
> 

I think the fact that "long long" was made official C in C99 is good
enough.  Flagging them as __extension__ is okay, I guess, but something
like this should definitely go in.

	-hpa
