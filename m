Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZFOG6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZFOG6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZFOG6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:58:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:2935 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbZFOG6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oM2BFLJwllK1H5EahpGtkoieFg1ayAVpZs8NuxtoD5xu4isWMrxIb4L3vNNBpPUb/k
         XEfPPN2IEq1xFzVRcbbjLv0pRWO9oh7uoecZhkjT/tv2r77Yh2fcqCrcL51ccrCOCgD+
         PPUulDtGWnnULHVvaGodE+qASjNuj22NFpkS4=
Date: Mon, 15 Jun 2009 15:00:18 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
Message-ID: <20090615070018.GD3544@cr0.nay.redhat.com>
References: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com> <4A2CC52B.9010602@oracle.com> <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com> <m1ab4i11zx.fsf@fess.ebiederm.org> <20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0> <m17hzg7oil.fsf@fess.ebiederm.org> <20090615021457.GA3388@cr0.nay.redhat.com> <4A35E32C.30609@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A35E32C.30609@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:59:08PM +0800, Tao Ma wrote:
> Hi Amerigo,
> 	Just patched my kernel and tested.
> 	The bad news is that although the number is changed, but it isn't right  
> either.

Thanks for testing.

What do you mean by saying it isn't right? You think it is wrong only because
it is more than phy mem size?

Again, the document of /proc/kcore is wrong, it _can_ be more than phy mem size.

Regards.
