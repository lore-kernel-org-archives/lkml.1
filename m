Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYKKVkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYKKVkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYKKVkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:40:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34077 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYKKVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:40:00 -0500
Message-ID: <4919FB95.4060105@redhat.com>
Date: Tue, 11 Nov 2008 23:39:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, chrisw@redhat.com,
       izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <20081111210655.GG10818@random.random> <Pine.LNX.4.64.0811111522150.27767@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811111522150.27767@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> page migration requires the page to be on the LRU. That could be changed
> if you have a different means of isolating a page from its page tables.
>   

Isn't rmap the means of isolating a page from its page tables?  I guess 
I'm misunderstanding something.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

