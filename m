Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZLFBji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZLFBji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZLFBjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:39:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbZLFBjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:39:33 -0500
Message-ID: <4B1B0BC9.7070005@gmail.com>
Date: Sun, 06 Dec 2009 02:41:29 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: matthew@wil.cx, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B199173.3050207@gmail.com> <20091206012329.GB14381@ZenIV.linux.org.uk>
In-Reply-To: <20091206012329.GB14381@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Dec 04, 2009 at 11:47:15PM +0100, Emese Revfy wrote:
>> From: Emese Revfy <re.emese@gmail.com>
>>
>> Constify struct super_operations.
> 
> What the _hell_ is that?
> 
>> +   	struct inode *(* const alloc_inode)(struct super_block *sb);
> 
> This is ugly and has all marks of cargo-cult patches.  NAKed at least
> until you give exceptionally good reasons for doing that.

My idea was that since each instance of super_operations is const,
I figured that there is an implicit policy of not wanting writable
super_operations structures in the kernel. If this is actually the
case then my patch makes the compiler enforce this policy, otherwise
please ignore it.
--
Emese

