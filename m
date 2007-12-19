Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXLSQoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXLSQoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbXLSQoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:44:38 -0500
Received: from rtr.ca ([76.10.145.34]:3656 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbXLSQoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:44:38 -0500
Message-ID: <47694A75.5000705@rtr.ca>
Date: Wed, 19 Dec 2007 11:44:37 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Bodo Eggert <7eggert@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <9BTqk-2ck-31@gated-at.bofh.it> <9BTJN-2Sv-21@gated-at.bofh.it> <9BTTr-35L-13@gated-at.bofh.it> <E1J4zCp-0003fj-5I@be1.7eggert.dyndns.org> <20071219142351.GI8181@ftp.linux.org.uk>
In-Reply-To: <20071219142351.GI8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Dec 19, 2007 at 02:43:26PM +0100, Bodo Eggert wrote:
> 
>> Since nobody knows about this "security boundary" and everybody knows about
>> the annoying "can't link across bind-mountpoints bug",
> 
> ... how about teaching people to RTFM?  Starting, perhaps, with man 2 link?
..

Mmm.. that's a programmers' man page, not a user/admin page.
Something in mv(1) would be very useful to have.

And perhaps a mount flag to select desired behaviour,
since virtually everyone expects it to "just work" that way,
and it doesn't.

I'll happily generate a patch if we can agree on the correctness
of the sample patch I posted earlier, plus a suitable mount flag name.

Cheers
