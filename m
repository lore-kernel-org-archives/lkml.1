Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZDNHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZDNHrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZDNHrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:47:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:37730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZDNHrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:47:08 -0400
Message-ID: <49E43F1D.3070400@kernel.org>
Date: Tue, 14 Apr 2009 16:45:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
References: <m1skkf761y.fsf@fess.ebiederm.org> <49E4000E.10308@kernel.org> <m13acbbs5u.fsf@fess.ebiederm.org>
In-Reply-To: <m13acbbs5u.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 07:45:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Do you know of a case where we actually have multiple tasks accessing
> a file simultaneously?

I don't have anything at hand but multithread/process server accepting
on the same socket comes to mind.  I don't think it would be a very
rare thing.  If you confine the scope to character devices or sysfs,
it could be quite rare tho.

> I just instrumented up my patch an so far the only case I have found
> are multiple processes closing the same file.  Some weird part of
> bash forking extra processes.

Hmmm...

Thanks.

-- 
tejun
