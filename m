Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYHDOOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYHDOOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbYHDONx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:13:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41016 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbYHDONw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:13:52 -0400
Message-ID: <48970DDD.4040607@cs.helsinki.fi>
Date: Mon, 04 Aug 2008 17:10:37 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
References: <20080801000405.GA7072@martell.zuzino.mipt.ru> <48941C2F.8010406@cs.helsinki.fi> <489702B9.5030204@linux-foundation.org>
In-Reply-To: <489702B9.5030204@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Pekka Enberg wrote:
>> Alexey Dobriyan wrote:
>>> Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
>>> to hell with tunables.
>> Applied, thanks!
> 
> Do not apply. This partially reverts an earlier commit and would cause build
> issues because the #ifdef parts in slub.c were not reverted.

Aww, crap. OK, taking it out.
