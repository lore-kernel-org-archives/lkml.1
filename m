Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXJWH6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXJWH6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXJWH6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:58:47 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:51157 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXJWH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:58:46 -0400
Message-ID: <471DA974.8060509@linux.vnet.ibm.com>
Date: Tue, 23 Oct 2007 13:27:40 +0530
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
References: <471D4523.4040509@google.com> <20071023024036.GC3324@linux.vnet.ibm.com> <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com> <6599ad830710230021n536908c0xd95250f36aa8a27d@mail.gmail.com> <471DA78F.4090600@linux.vnet.ibm.com> <6599ad830710230053l35fffaf5ld8882eaae8b9df7c@mail.gmail.com>
In-Reply-To: <6599ad830710230053l35fffaf5ld8882eaae8b9df7c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 10/23/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Well, most people who care about deletion will use the notify_on_release
>> callback and retry.
> 
> I'm not convinced this is true. Certainly the userspace approaches
> we're developing at Google don't (currently) use notify_on_release.
> 
> Paul

Well, without notify_on_release you can never be sure if a new task
got added to the control group or if someone acquired a reference
to it. I can't think of a safe way of removing control groups/cpusets
without using notify_on_release.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

