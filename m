Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZCVFwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZCVFwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 01:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZCVFwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 01:52:32 -0400
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2517 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZCVFwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 01:52:31 -0400
Message-ID: <49C5D217.2010201@xs4all.nl>
Date: Sun, 22 Mar 2009 06:52:23 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: linux-kernel@vger.kernel.org, Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: 2.6.28.2 kernel bug
References: <49C52958.7030700@xs4all.nl> <Pine.LNX.4.64.0903212014380.15606@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0903212014380.15606@blonde.anvils>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> This would become more interesting if you are able to reproduce it,

Just restarted the find command again, crashed after about 7 hours, this 
time with just one line in messages, about the bad page state for `find` 
again.

> or something like it - is that massive removal of files something
> you often do without a problem, or was this new?  What does your
> find/rm command line look like?  I'm wondering if we have a bug
> with exceptionally long arg lists.

I ran a find to get rid of ~2.5M files in 
~/.beagle/Indexes/Thunderbird/ToIndex which shouldn't have been there:
find ToIndex -type f -exec rm -f {} \;
This find runs pretty slowish.

The 2nd time I ran a sync severy 123 seconds to avoid big troubles in 
case of a crash.

Now I just made a list of all files and have a small shell script delete 
the files one by one.


I seldomly have these amounts of files to delete.
I never have this specific problem logged. (as far as I recall for this box)
It is typical that `find` triggers it and not cc1, Xorg etc.
