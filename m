Return-Path: <linux-kernel-owner+w=401wt.eu-S2992438AbXDDCx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992438AbXDDCx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992535AbXDDCx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:53:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:33961 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2992438AbXDDCx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:53:27 -0400
X-Authenticated: #420190
X-Provags-ID: V01U2FsdGVkX1+gdSoZCN2gDb/MqiRCUSakID4Vh/zJhpFfTFhF6Z
	Gp6IXzdB5nIlll
Message-ID: <4613131A.2060206@gmx.net>
Date: Wed, 04 Apr 2007 04:53:14 +0200
From: Marko Macek <Marko.Macek@gmx.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>
In-Reply-To: <46128051.9000609@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> A solution for this problem is a madvise() operation with the following
> property:
> 
>   - the content of the address range can be discarded
> 
>   - if an access to a page in the range happens in the future it must
>     succeed.  The old page content can be provided or a new, empty page
>     can be provided

Doesn't this conflict with disabling overcommit?

If the page is guaranteed to be available, obviously it must count as
being commited, so this is not equivalent to real freeing.

Mark
