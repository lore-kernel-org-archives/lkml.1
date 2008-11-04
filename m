Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYKDP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYKDP5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYKDP4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:56:51 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:63544 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYKDP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:56:51 -0500
Message-ID: <491070B5.2060209@nortel.com>
Date: Tue, 04 Nov 2008 09:56:37 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
Subject: Re: mmap: is default non-populating behavior stable?
References: <490F73CD.4010705@gmail.com> <1225752083.7803.1644.camel@twins> <490F8005.9020708@redhat.com>
In-Reply-To: <490F8005.9020708@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2008 15:56:39.0037 (UTC) FILETIME=[EC2FBAD0:01C93E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Peter Zijlstra wrote:

>> The exact interaction of mmap() and truncate() I'm not exactly clear on.
> 
> Truncate will reduce the size of the mmaps on the file to
> match the new file size, so processes accessing beyond the
> end of file will get a segmentation fault (SIGSEGV).

I suspect Peter was talking about using truncate() to set the initial 
file size, effectively increasing rather than reducing it.

Chris
