Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYHKIsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYHKIsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYHKIse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:48:34 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17428 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbYHKIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:48:33 -0400
Message-ID: <489FFCB0.7080509@panasas.com>
Date: Mon, 11 Aug 2008 11:47:44 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] uninline nfsd4_op_name()
References: <20080808162642.GG14495@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808081120570.3462@nehalem.linux-foundation.org> <489ED1CF.8000308@panasas.com> <20080811030339.GA5621@fieldses.org>
In-Reply-To: <20080811030339.GA5621@fieldses.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2008 08:47:04.0610 (UTC) FILETIME=[D4518820:01C8FB8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug. 11, 2008, 6:03 +0300, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Sun, Aug 10, 2008 at 02:32:31PM +0300, Benny Halevy wrote:
>> Linus Torvalds wrote:
>>> On Fri, 8 Aug 2008, Adrian Bunk wrote:
>>>> There doesn't seem to be a compelling reason why nfsd4_op_name() is 
>>>> marked as "inline":
>> Agreed.
>>
>>> It should also return a "const char *", I think.
>>>
>>> Since it does.
>> Right.
> 
> OK, I modified that to add "const" as Linus suggests, and applied to
> 
> 	git://linux-nfs.org/~bfields/linux.git for-2.6.27
> 
> Thanks to everyone.
> 
> --b.

Bruce, Linus already corrected and merged Adrian's patch in
linux-2.6/master as commit f1c7f79b6ab4f7ada002a0fae47f462ede6b6857

Benny
