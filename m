Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZEZNAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZEZNAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZEZNAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:00:36 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:46152 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZEZNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:00:35 -0400
X-AuditID: b753bd60-a7cf8ba00000617e-f9-4a1be5a5bcf9
Message-ID: <4A1BE58A.9060708@hitachi.com>
Date: Tue, 26 May 2009 21:50:18 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [0/16] POISON: Intro
References: <20090407509.382219156@firstfloor.org>
In-Reply-To: <20090407509.382219156@firstfloor.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
(I'm sorry for the very late comment.)

Andi Kleen wrote:

> Upcoming Intel CPUs have support for recovering from some memory errors. This
> requires the OS to declare a page "poisoned", kill the processes associated
> with it and avoid using it in the future. This patchkit implements
> the necessary infrastructure in the VM.

I think this patch set is a great step to get the Linux system
reliable close to mainframe.  I really appreciate your work.

I believe people concerning high reliable system are expecting
this kind of functionality.
But I wonder why this patch set (including former MCE improvements
patches) has not been merged into any subsystem trees yet.
What is the problem?  Because of the deadlock bug and the ref counter
problem?  Or are we waiting for 32bit unification to complete?
If so, I'd like to try to narrow down the problems or review
patches (although I'm afraid I'm not so skillful).

BTW, I looked over this patch set, and I couldn't
find any problems except for one minor point.  I'll post
a comment about it later.  It is very late, but better than nothing.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

