Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZBWKze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZBWKze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZBWKzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:55:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZBWKzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:55:24 -0500
Message-ID: <49A28098.5040906@redhat.com>
Date: Mon, 23 Feb 2009 12:55:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: fix another largepage memory leak
References: <1235042336-20101-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1235042336-20101-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> In the paging_fetch function rmap_remove is called after setting a large
> pte to non-present. This causes rmap_remove to not drop the reference to
> the large page. The result is a memory leak of that page.
>
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

