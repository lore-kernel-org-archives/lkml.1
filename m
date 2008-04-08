Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbYDHN4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbYDHN4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYDHNzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:55:54 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:41056 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYDHNzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CjjscaVtGGODKO/EqrQ/A05JmSL0tUFGfTRixC+Ei2wAQ9nQR4b0mWEwRP1Wxp8q5wctC3P567AGANa1V3lVjJAlF6f/fSYMuamxxKFK19aJQtqsF+B4MYCbvLImI8/SLFW2w54ULzCbRrX9dypEvb44E9fnnX9AKENxvdHDS1w=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: "Paul Menage" <menage@google.com>
Subject: Re: [RFC][-mm] [0/2] Basic stats for cgroups V2
Date: Tue, 8 Apr 2008 19:19:14 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com, a.p.zijlstra@chello.nl,
       "Ingo Molnar" <mingo@elte.hu>
References: <200804052339.42474.balajirrao@gmail.com> <6599ad830804080036h5496e3bdv9ac2dedf0f04f9bc@mail.gmail.com>
In-Reply-To: <6599ad830804080036h5496e3bdv9ac2dedf0f04f9bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081919.14601.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2008 01:06:17 pm Paul Menage wrote:
> 
> One of the important API choices would be whether the stats API was
> fixed in header files shared with userspace, or whether it would be
> possible for stats to be added and dynamically discovered/used by
> userspace without needing fixed header file descriptions.
> 
The second idea is much better, I feel.

> The difference would be a bit like the old sysctl API (where each
> sysctl entry had to be enumerated in a header file) versus the newer
> /proc/sys approach where numerical values aren't used and userspace
> can determine which entries are supported at runtime, and even access
> new previously-unknown entries.
> 

<snip>

> 
> Thoughts?

Overall the idea looks good to me.

We are also looking at a generic framework in cgroups that would delegate the 
job of handling statistics to the cgroup framework itself. This would avoid 
code duplication across various controllers.

-- 
regards,
Balaji Rao
