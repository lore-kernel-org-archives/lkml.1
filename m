Return-Path: <linux-kernel-owner+w=401wt.eu-S1764056AbXGFRTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764056AbXGFRTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762622AbXGFRT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:19:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:38768 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761199AbXGFRT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:19:26 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Hiroaki Fuse <Hiroaki_Fuse@hq.scei.sony.co.jp>
Subject: Re: Too verbose compat_ioctl messages?
References: <Pine.LNX.4.62.0707061431360.1203@pademelon.sonytel.be>
	<468E6E33.3040000@zytor.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Jul 2007 20:14:39 +0200
In-Reply-To: <468E6E33.3040000@zytor.com>
Message-ID: <p737ipd1jsg.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
> 
> For one thing, it looks like we're returning the wrong thing (EINVAL
> rather than ENOTTY) across the board.  This was unfortunately a common
> misunderstanding with non-tty-related ioctls in the early days of Linux.

ENOTTY is so excessively misnamed that it is actually surprising
anybody ever got that "right" (for very small values of right i guess)

-Andi
