Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZIGQqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZIGQqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZIGQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZIGQqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:46:53 -0400
Message-ID: <4AA53AB0.8030508@redhat.com>
Date: Mon, 07 Sep 2009 19:54:08 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/3] ksm: mremap use err from ksm_madvise
References: <Pine.LNX.4.64.0909052219580.7381@sister.anvils> <Pine.LNX.4.64.0909052225250.7387@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909052225250.7387@sister.anvils>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> mremap move's use of ksm_madvise() was assuming -ENOMEM on failure,
> because ksm_madvise used to say -EAGAIN for that; but ksm_madvise now
> says -ENOMEM (letting madvise convert that to -EAGAIN), and can also
> say -ERESTARTSYS when signalled: so pass the error from ksm_madvise.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>   
Acked-by: Izik Eidus <ieidus@redhat.com>
