Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYKKVYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYKKVYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYKKVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:24:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYKKVY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:24:29 -0500
Message-ID: <4919F7EE.3070501@redhat.com>
Date: Tue, 11 Nov 2008 23:23:58 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <4919F1C0.2050009@redhat.com> <Pine.LNX.4.64.0811111520590.27767@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811111520590.27767@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> page migration as far as i saw cant migrate anonymous page into kernel page.
>> if you want we can change page_migration to do that, but i thought you will
>> rather have ksm changes separate.
>>     
>
> What do you mean by kernel page? The kernel can allocate a page and then
> point a user space pte to it. That is how page migration works.
>   
i mean filebacked page (!AnonPage())
ksm need the pte inside the vma to point from anonymous page into 
filebacked page
can migrate.c do it without changes?
