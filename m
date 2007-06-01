Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbXFAQkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbXFAQkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbXFAQjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:39:55 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:2273 "EHLO
	sc-analyser1.mxsweep.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757945AbXFAQjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:39:54 -0400
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 12:39:54 EDT
Message-ID: <466047BB.3040302@draigBrady.com>
Date: Fri, 01 Jun 2007 17:22:19 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com>
In-Reply-To: <466040C1.6030004@zytor.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Mlf-Version: 5.0.3.8711
X-Mlf-UniqueId: o200706011624290114106
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Eric Dumazet wrote:
>> As I said, this new non blocking feature on the input side (disk), is
>> nice and usefull. (For people scared by splice() syscall :) )
>>
>> Just have to mention it is a change of behavior, and documentation
>> probably needs to reflect this change. "Since linux 2.6.23, sendfile()
>> repects O_NONBLOCK on in_fd as well"
>>
> 
> Fair enough.  Unix has traditionally not acknowledged the possibility of
> nonblocking I/O on conventional files, for some odd reason.

That reminds me of this patch:
http://lkml.org/lkml/2004/10/1/217
which went in for a while but was reverted:
http://lkml.org/lkml/2004/10/17/17

Pádraig
