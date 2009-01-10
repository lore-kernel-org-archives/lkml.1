Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZAJTll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZAJTll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 14:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZAJTld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 14:41:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35519 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZAJTlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 14:41:32 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?J=C3=B6rn?= Engel <joern@logfs.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
From: Andi Kleen <andi@firstfloor.org>
References: <1231584446.3685.21.camel@johannes>
	<2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
	<1231587428.3803.0.camel@johannes>
	<2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
	<20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes>
Date: Sat, 10 Jan 2009 20:41:03 +0100
In-Reply-To: <1231613042.3706.16.camel@johannes> (Johannes Berg's message of "Sat, 10 Jan 2009 19:44:02 +0100")
Message-ID: <87fxjrgd9s.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> Also, to elaborate on that answer, I'm going to use this as a sort of
> hash table for wireless, where it ensures better scalability than a pure
> hashtable from quiet environments (say wireless off on an airplane) to
> your wireless test lab (100+ access points)

Is there any particular reason you can't use the standard rbtrees
for that?

-Andi
-- 
ak@linux.intel.com
