Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYCZPsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYCZPsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYCZPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:48:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43711 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbYCZPsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:48:03 -0400
Message-ID: <47EA7030.2080301@sgi.com>
Date: Wed, 26 Mar 2008 08:48:00 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] NR_CPUS: third reduction of NR_CPUS memory usage
 x86-version v2
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080326063401.GE18301@elte.hu>
In-Reply-To: <20080326063401.GE18301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Wii, isn't this fun...!  This is a resubmission of yesterday's patches 
>> based on the x86.git/latest tree.  Yes, it _is_ a maze of twisty litle 
>> passages. ;-)
> 
> just to make patch dependencies clear: most of the patches here can be 
> applied to their base trees as-is, without depending on any other patch, 
> correct?
> 
> the only undeclared dependency i found was the cpumask_scnprintf_len() 
> patch - please prominently list dependencies in the changelog like this:
> 
>  [ this patch depends on "cpumask: Add cpumask_scnprintf_len function" ]
> 
> 	Ingo


Ahh, ok.  I was under the assumption that an entire patchset would be
applied en-mass and only divided up by bi-sect debugging...?

The second patchset (cpumask) is highly incremental and I did it like
this to show memory gains (or losses).  I tossed a few patches that
didn't have any overall goodness (and have a few more to help with
the memory footprint or performance in the queue.)

Thanks,
Mike
