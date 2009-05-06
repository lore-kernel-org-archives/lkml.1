Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbZEFA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbZEFA5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZEFA5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:57:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58545 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZEFA5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:57:01 -0400
Message-ID: <4A00DF9B.1080501@redhat.com>
Date: Tue, 05 May 2009 20:53:47 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241475935-21162-4-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> This patch change the KSM_REMOVE_MEMORY_REGION ioctl to be specific per
> memory region (instead of flushing all the registred memory regions inside
> the file descriptor like it happen now)
> 
> The previoes api was:
> user register memory regions using KSM_REGISTER_MEMORY_REGION inside the fd,
> and then when he wanted to remove just one memory region, he had to remove them
> all using KSM_REMOVE_MEMORY_REGION.
> 
> This patch change this beahivor by chaning the KSM_REMOVE_MEMORY_REGION
> ioctl to recive another paramter that it is the begining of the virtual
> address that is wanted to be removed.

This is different from munmap and madvise, which take both
start address and length.

Why?

-- 
All rights reversed.
