Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXFAFyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXFAFyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXFAFy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:54:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXFAFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:54:28 -0400
Message-ID: <465FB3AD.5030807@zytor.com>
Date: Thu, 31 May 2007 22:50:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk>
In-Reply-To: <20070601054120.GI32105@kernel.dk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>>>
>> I would personally argue that sendfile() blocking on an O_NONBLOCK
>> desriptor, as opposed to returning EAGAIN, is a bug, and a fairly
>> serious such.
> 
> I agree, but it's still a change in behaviour. Even if we consider the
> app buggy (it is), can we potentially break it?
> 

It depends on which app it is, of course.  However, I think we have to
smoke that out the hard way.  I don't think we should retain a bug in
the kernel just because some unknown app might depend on that bug --
taking that to the extreme  we could never fix bugs at all...

	-hpa
