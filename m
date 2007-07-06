Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbXGFRtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbXGFRtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbXGFRs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:48:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbXGFRs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:48:59 -0400
Message-ID: <468E8064.6000107@zytor.com>
Date: Fri, 06 Jul 2007 10:48:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Hiroaki Fuse <Hiroaki_Fuse@hq.scei.sony.co.jp>
Subject: Re: Too verbose compat_ioctl messages?
References: <Pine.LNX.4.62.0707061431360.1203@pademelon.sonytel.be>	<468E6E33.3040000@zytor.com> <p737ipd1jsg.fsf@bingen.suse.de>
In-Reply-To: <p737ipd1jsg.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>> For one thing, it looks like we're returning the wrong thing (EINVAL
>> rather than ENOTTY) across the board.  This was unfortunately a common
>> misunderstanding with non-tty-related ioctls in the early days of Linux.
> 
> ENOTTY is so excessively misnamed that it is actually surprising
> anybody ever got that "right" (for very small values of right i guess)
> 

No argument there.

	-hpa
