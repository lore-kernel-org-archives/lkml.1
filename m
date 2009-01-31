Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZAaFsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZAaFsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbZAaFs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:48:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:46201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZAaFs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:48:28 -0500
Message-ID: <4983E5D3.3040100@kernel.org>
Date: Sat, 31 Jan 2009 14:46:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org>
In-Reply-To: <49833350.1020809@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 31 Jan 2009 05:47:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Please disregard the previous two rebased trees.  There has been a
major communication misunderstanding between Ingo and me leading to
the rebased branches.  Here is yet another, hopefully final, merged
tree which builds on top of tip/core/percpu and took only about ten
minutes as opposed to hours.  :-)

* Three xen fix related patches merged.  Later threes conflicted in
  non-minor way.  Requested refresh.

* Cliff Wickman's UV flush fix patch revived and merged.

* Pull in linus#master[1].

Anyways, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

The commit ID should be da2c0b021cde94866f1e492f940aad29e8f61258.

Sorry about the mess but this one should be the safe one to post
patches against.

Thanks.

-- 
tejun

[1] 33bfad54b58cf05cfe6678c3ec9235d4bc8db4c2
