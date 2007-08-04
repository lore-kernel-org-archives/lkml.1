Return-Path: <linux-kernel-owner+w=401wt.eu-S935606AbXJQQDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935606AbXJQQDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965631AbXJQQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:02:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37826 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965906AbXJQQCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:02:44 -0400
Message-ID: <46B3D34B.6010105@sgi.com>
Date: Fri, 03 Aug 2007 18:15:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: Convert cpuinfo_x86 array to a per_cpu array
 v3
References: <20070924210853.256462000@sgi.com> <20071016011827.91350174.akpm@linux-foundation.org>
In-Reply-To: <20071016011827.91350174.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
...
>> ...  This patch deals with the cpu_data array of
>> cpuinfo_x86 structs.  The model that was used in sparc64
>> architecture was adopted for x86.
>>
> 
> This has mysteriously started to oops on me, only on x86_64.
> 
> http://userweb.kernel.org/~akpm/config-x.txt
> http://userweb.kernel.org/~akpm/dsc00001.jpg
> 
> which is a bit strange since this patch doesn't touch sched.c.  Maybe
> there's something somewhere else in the -mm lineup which when combined with
> this prevents it from oopsing, dunno.  I'll hold it back for now and will
> see what happens.
> 

I'll take a look at this right away.

Thanks,
Mike

