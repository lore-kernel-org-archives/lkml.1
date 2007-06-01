Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXFAP5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXFAP5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbXFAP5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:57:42 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbXFAP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:57:41 -0400
Message-ID: <466040C1.6030004@zytor.com>
Date: Fri, 01 Jun 2007 08:52:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com>
In-Reply-To: <465FC92C.50608@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> 
> As I said, this new non blocking feature on the input side (disk), is
> nice and usefull. (For people scared by splice() syscall :) )
> 
> Just have to mention it is a change of behavior, and documentation
> probably needs to reflect this change. "Since linux 2.6.23, sendfile()
> repects O_NONBLOCK on in_fd as well"
> 

Fair enough.  Unix has traditionally not acknowledged the possibility of
nonblocking I/O on conventional files, for some odd reason.

	-hpa
