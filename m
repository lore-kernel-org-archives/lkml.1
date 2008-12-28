Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYL1XDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYL1XDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYL1XDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:03:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYL1XDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:03:41 -0500
Message-ID: <495805AE.5000000@zytor.com>
Date: Sun, 28 Dec 2008 15:03:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Mike Frysinger <vapier@gentoo.org>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081228223534.GA6287@joi>
In-Reply-To: <20081228223534.GA6287@joi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
>> Use __asm__/__inline__ rather than asm/inline for all the functions
>> exported to userspace.
> 
> Why? I can't find anything related in Documentation/.

Because "asm" and "inline" are unsafe keywords in arbitrary C code, as
may be encountered in userspace.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

