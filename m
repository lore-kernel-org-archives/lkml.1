Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbZLWQcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbZLWQcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZLWQcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:32:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZLWQcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:32:09 -0500
Date: Wed, 23 Dec 2009 17:32:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091223163203.GG20539@basil.fritz.box>
References: <20091207115949.GA7610@basil.fritz.box> <20091207211216.E95E.A69D9226@jp.fujitsu.com> <20091207132009.GI18989@one.firstfloor.org> <20091215222134.GA27892@ZenIV.linux.org.uk> <20091215233841.GE22392@basil.fritz.box> <1260921277.3219.18.camel@localhost> <20091216000924.GZ14381@ZenIV.linux.org.uk> <1260969392.3219.65.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260969392.3219.65.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The scenario would be that the writing thread triggers a page fault
> (through __get_user()) when holding the i_mutex, while the other thread
> is trying to grab the i_mutex within the mmap() call.

Hi Trond,

What's the state of this bug? Are you going to accept my patch
or do you have a different one in the pipeline?

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
