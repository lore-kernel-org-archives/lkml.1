Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbXJWHuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbXJWHuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXJWHt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:49:58 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:48162 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXJWHt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:49:57 -0400
Message-ID: <471DA78F.4090600@linux.vnet.ibm.com>
Date: Tue, 23 Oct 2007 13:19:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: vatsa@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
References: <471D4523.4040509@google.com> <20071023024036.GC3324@linux.vnet.ibm.com> <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com> <6599ad830710230021n536908c0xd95250f36aa8a27d@mail.gmail.com>
In-Reply-To: <6599ad830710230021n536908c0xd95250f36aa8a27d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 10/22/07, Paul Menage <menage@google.com> wrote:
>> Using cgroup_mutex is certainly possible for now, although more
>> heavy-weight than I'd like long term. Using css_get isn't the right
>> approach, I think - we shouldn't be able to cause an rmdir to fail due
>> to a concurrent read.
>>

Well, most people who care about deletion will use the notify_on_release
callback and retry. I think we have a good mechanism in place for
deletion, so I would not worry about read delaying deletion.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

