Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXFAGs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXFAGs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbXFAGss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:48:48 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:60410 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXFAGsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:48:47 -0400
Message-ID: <465FC12A.5040708@linux.vnet.ibm.com>
Date: Fri, 01 Jun 2007 12:18:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 5/8] RSS accounting hooks over the code
References: <465D9739.8070209@openvz.org> <465D997A.3030706@openvz.org> <20070530144629.09dad0df.akpm@linux-foundation.org>
In-Reply-To: <20070530144629.09dad0df.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 30 May 2007 19:34:18 +0400
> Pavel Emelianov <xemul@openvz.org> wrote:
> 
>> As described above, pages are charged to their first touchers.
>> The first toucher is determined using pages' _mapcount 
>> manipulations in rmap calls.
>>
>> Page is charged in two stages:
>> 1. preparation, in which the resource availability is checked.
>>    This stage may lead to page reclamation, thus it is performed
>>    in a "might-sleep" places;
>> 2. the container assignment to page. This is done in an atomic
>>    code that handles races between multiple touchers.
> 
> I suppose we need to think about what to do about higher-order pages, and
> compound pages, and hugetlb memory.

Yes, that needs to be done eventually. I feel that support can be added
incrementally once we have a stable controller.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
