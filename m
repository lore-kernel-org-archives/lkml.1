Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZHDTaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZHDTaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZHDTaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:30:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44471 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbZHDTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:30:04 -0400
Message-ID: <4A788D32.1090300@redhat.com>
Date: Tue, 04 Aug 2009 22:34:10 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/12] ksm: sysfs and defaults
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031318220.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031318220.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> At present KSM is just a waste of space if you don't have CONFIG_SYSFS=y
> to provide the /sys/kernel/mm/ksm files to tune and activate it.
>
> Make KSM depend on SYSFS?  Could do, but it might be better to provide
> some defaults so that KSM works out-of-the-box, ready for testers to
> madvise MADV_MERGEABLE, even without SYSFS.
>
> Though anyone serious is likely to want to retune the numbers to their
> taste once they have experience; and whether these settings ever reach
> 2.6.32 can be discussed along the way.  
>
> Save 1kB from tiny kernels by #ifdef'ing the SYSFS side of it.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>   

Acked-By: Izik Eidus <ieidus@redhat.com>
