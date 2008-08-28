Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYH1U5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYH1U5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYH1U5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:57:31 -0400
Received: from flusers.ccur.com ([12.192.68.2]:57718 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754552AbYH1U5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:57:31 -0400
Date: Thu, 28 Aug 2008 16:57:27 -0400
From: Joe Korty <joe.korty@ccur.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFSv3: cached permissions subset enhancement, v2
Message-ID: <20080828205727.GA21880@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827142820.GA22661@tsunami.ccur.com> <2BBFD074-16C3-4640-8F3D-DF604F4146A7@netapp.com> <20080828182848.GA19286@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828182848.GA19286@tsunami.ccur.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 02:28:48PM -0400, Joe Korty wrote:
> On Thu, Aug 28, 2008 at 12:03:47PM -0400, Myklebust, Trond wrote:
>> This isn't a good solution. The correct thing to do here is to resend
>> the request for just those permissions that the VFS requested.
> 
> Is there any chance that the cached permissions are shared amoung
> multiple open(2)'s of the same file?  If sharing happens then we
> really need to cache all of MAY_EXEC | MAY_WRITE | MAY_READ, rather
> than just that subset asked for by the open(2) that happens to
> be the one filling in the cache.
> 
> In any case, I've rewritten the patch per the above suggestion, and


Hi Trond,
I've tested the new patch with the test sequence mentioned in the
original customer bug report, and it seems to work.

Joe
