Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYKURcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYKURcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYKURcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:32:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:46647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYKURcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:32:05 -0500
Message-ID: <4926F085.4060903@kernel.org>
Date: Sat, 22 Nov 2008 02:31:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: torvalds@linux-foundation.org, hch@infradead.org, mingo@elte.hu,
       rminnich@sandia.gov, ericvh@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] poll: allow f_op->poll to sleep, take #2
References: <491BA16C.30606@kernel.org> <alpine.LFD.2.00.0811151208430.3468@nehalem.linux-foundation.org> <49256CCE.9060107@kernel.org> <E1L3Z5h-0008J7-QN@pomaz-ex.szeredi.hu> <4926EBD8.6070200@kernel.org> <E1L3Zif-0008SF-S1@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L3Zif-0008SF-S1@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Nov 2008 17:31:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Sat, 22 Nov 2008, Tejun Heo wrote:
>> For both, I was trying to stay consistent with the environment.  I
>> find mixed styles in close proximity much uglier than slightly
>> different but consistent style.  Eh... Is the consensus checkpatch or
>> die?
> 
> I think some common sense can be applied in these cases.  For example
> a small amount of offending style in close proximity can be fixed as
> well, as long as it doesn't interfere too much with the readability of
> the patch.

Well, yeah, given that fs/select.c is not a very hot file.  Introduced
inconsistencies are gonna stay there for a long time.  The two issues
in this patch is minor and can be easily adjusted but in general I'm
not too sure whether always sticking with checkpatch is a good idea
especially on fairly cold areas.  Anyways, I'll fix it up.

Thanks.

-- 
tejun
