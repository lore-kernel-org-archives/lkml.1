Return-Path: <linux-kernel-owner+w=401wt.eu-S937710AbXHIHFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937710AbXHIHFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXHIHFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:05:23 -0400
Received: from 5.xs4all.nl ([82.95.233.223]:34905 "EHLO capsaicin.mamane.lu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754133AbXHIHFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:05:21 -0400
X-Greylist: delayed 2401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 03:05:21 EDT
Date: Thu, 9 Aug 2007 08:25:11 +0200
From: Lionel Elie Mamane <lionel@mamane.lu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingcha@pimp.vs19.net
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070809062511.GA23435@capsaicin.mamane.lu>
Mail-Followup-To: Lionel Elie Mamane <lionel@mamane.lu>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, miklos@szeredi.hu,
	akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
	tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingcha@pimp.vs19.net
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <20070804163733.GA31001@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804163733.GA31001@elte.hu>
X-Operating-System: GNU/Linux
X-Request-PGP: http://www.mamane.lu/openpgp/rsa_v4_4096.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 06:37:33PM +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:

>> The fact is, ext3 *sucks* at fsync. I hate hate hate it. It's
>> totally unusable, imnsho.

> yeah, it's really ugly. But otherwise i've got no real complaint
> about ext3 - with the obligatory qualification that
> "noatime,nodiratime" in /etc/fstab is a must. This speeds up things
> very visibly (...). So for most file workloads we give Windows a
> 20%-30% performance edge, for almost nothing.

It has been years since I used MS Windows much, but from my memories
of my these days, I was under the impression that it (at least the NT
line, the only surviving line these days) also maintained "last
accessed" times. Except I only ever saw it at "right now" because the
file explorer ... accesses the file before getting this metadata or
something like that (when you right-click on a file and ask for its
properties). It has creation and last modification time, too.

So, if my memories are correct, there is no performance edge to be
conceded by having atime (but one to be gained by not having atime).

-- 
Lionel
