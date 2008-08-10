Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYHJLdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYHJLdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 07:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYHJLdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 07:33:18 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:28521 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754209AbYHJLdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 07:33:17 -0400
Message-ID: <489ED1CF.8000308@panasas.com>
Date: Sun, 10 Aug 2008 14:32:31 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
CC: "J. Bruce Fields" <bfields@citi.umich.edu>, neilb@suse.de,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] uninline nfsd4_op_name()
References: <20080808162642.GG14495@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808081120570.3462@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808081120570.3462@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2008 11:31:52.0066 (UTC) FILETIME=[AF49D620:01C8FADC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 8 Aug 2008, Adrian Bunk wrote:
>> There doesn't seem to be a compelling reason why nfsd4_op_name() is 
>> marked as "inline":

Agreed.

> 
> It should also return a "const char *", I think.
> 
> Since it does.

Right.

> 
> 		Linus

Thanks for picking this up,

Benny
