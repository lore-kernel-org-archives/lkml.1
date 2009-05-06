Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZEFM2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZEFM2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbZEFM2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:28:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36364 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbZEFM2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:28:05 -0400
Message-ID: <4A0181EA.3070600@redhat.com>
Date: Wed, 06 May 2009 08:26:18 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com> <4A015C69.7010600@redhat.com>
In-Reply-To: <4A015C69.7010600@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> Rik van Riel wrote:
>> Izik Eidus wrote:
>>> subjects say it all.
>>
>> Not a very useful commit message.
>>
>> This makes me wonder, though.
>>
>> What happens if a user mmaps a 30MB memory region, registers it
>> with KSM and then unmaps the middle 10MB?
> 
> User cant break 30MB into smaller one.

The user can break up the underlying VMAs though.

I am just wondering out loud if we really want two
VMA-like objects in the kernel, the VMA itself and
a separate KSM object, with different semantics.

Maybe this is fine, but I do think it's a question
that needs to be thought about.

-- 
All rights reversed.
