Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYE1FG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYE1FG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYE1FGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:06:22 -0400
Received: from smtp.nokia.com ([192.100.105.134]:28020 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYE1FGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:06:21 -0400
Message-ID: <483CE7AA.2040304@yandex.ru>
Date: Wed, 28 May 2008 08:03:38 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Artem.Bityutskiy@nokia.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can UBIFS be taken to linux-next?
References: <483BA79F.9030100@nokia.com>        <20080528114112.b8600074.sfr@canb.auug.org.au> <20080527192942.f4e3dd7b.akpm@linux-foundation.org>
In-Reply-To: <20080527192942.f4e3dd7b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2008 05:05:04.0314 (UTC) FILETIME=[63D269A0:01C8C080]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I'm not aware of any issues which would block a 2.6.27 merge.
> 
> I haven't reviewed the filesystem myself.  Christoph Hellwig seems to
> have had a good go through it and had numerous review comments, but it
> is unclear what stage things are at with addressing them?

Indeed Christoph made a good go through and we appreciate this. We have
addressed most of his requests. I'll just cite the latest UBIFS submit
mail (http://marc.info/?l=linux-kernel&m=121180458401234&w=2):

* Requests from Christoph Hellwig's review (may be found here:
  http://marc.info/?l=linux-kernel&m=121093446502796&w=2). Few things
  related to the background thread were not done though. Here are
  explanations why: http://marc.info/?l=linux-kernel&m=121155640026661&w=2
  and http://marc.info/?l=linux-kernel&m=121119680522445&w=2 (see end
  of the mail).
  Also, we have not changed readdir() implementation so far, but just
  put a comment that we cannot support NFS at the moment. However, we
  have an idea how to fix this, but need some comments from the community.
  We'll send a separate mail describing the problem and the possible
  solution shortly. Nevertheless, this should not be a blocker.

We are currently working on "state-less" (in Christoph's terminology)
readdir() implementation. Here is what we are doing:
http://marc.info/?l=linux-kernel&m=121181030711128&w=2

Would be nice to get some comments on 2 possible issues which will
be present in the new implementation.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
