Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0CEQDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:03:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab0CEQDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:03:40 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: M vd S <mvds.00@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <4B904D98.50602@gmail.com> <4B9060DE.4080104@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 05 Mar 2010 11:03:37 -0500
In-Reply-To: <4B9060DE.4080104@gmail.com> (M. vd S.'s message of "Fri, 05 Mar
	2010 02:39:42 +0100")
Message-ID: <x49sk8ezrfq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M vd S <mvds.00@gmail.com> writes:

>> > > If O_NONBLOCK is meaningful whatsoever (see man page docs for
>> > > semantics) against block devices, one would expect a nonblocking io
>> >
>> > It isn't...
>>
>> Thanks for the reply. It's good to get confirmation that I am not all
>> alone in an alternate non blocking universe. The linux man pages
>> actually had me convinced O_NONBLOCK would actually keep a process
>> from blocking on device io :-)
>>
>
> You're even less alone, I'm running into the same issue just now. But
> I think I've found a way around it, see below.

I guess I should note that I've suggested nonblocking I/O for files
before:

  http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-10/0290.html

I'll also note that enabling such a patch broke apps that accessed cd
burners, for example, since O_NONBLOCK had some preexisting semantics
there that I fail to recall.

Cheers,
Jeff
