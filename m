Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZGTShe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZGTShe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZGTShd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:37:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34824 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbZGTShc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:37:32 -0400
Message-ID: <4A64B964.2080307@redhat.com>
Date: Mon, 20 Jul 2009 14:37:24 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 08/10] ksm: prevent mremap move poisoning
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com> <1247851850-4298-6-git-send-email-ieidus@redhat.com> <1247851850-4298-7-git-send-email-ieidus@redhat.com> <1247851850-4298-8-git-send-email-ieidus@redhat.com> <1247851850-4298-9-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-9-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> KSM's scan allows for user pages to be COWed or unmapped at any time,
> without requiring any notification.  But its stable tree does assume
> that when it finds a KSM page where it placed a KSM page, then it is
> the same KSM page that it placed there.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
