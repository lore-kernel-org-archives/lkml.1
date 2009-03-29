Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZC2LjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZC2LjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZC2Liv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:38:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZC2Liu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:38:50 -0400
Message-ID: <49CF5DBF.3030305@redhat.com>
Date: Sun, 29 Mar 2009 14:38:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] kvm mmu: infrastructure changes for multiple huge
 page support
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1238164319-16092-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch includes most of the necessary changes to the KVM SoftMMU for
> supporting more than one huge page size. The changes in this patch
> include:
>
>   * introduce 'enum kvm_page_size' which is used to represent the page
>     size used
>   

How about the concept of page_level instead, which returns the level of 
a page in terms of the paging hierarchy?  Would be easier to compare 
against in the various walkers.

I've been thinking for a while to make levels zero-based, so 0 would be 
a 4K page, 1 a 2M page, and 2 a 1GB page.




-- 
error compiling committee.c: too many arguments to function

