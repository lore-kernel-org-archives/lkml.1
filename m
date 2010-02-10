Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0BJRJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:09:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab0BJRJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:09:36 -0500
Message-ID: <4B72E81D.9020409@redhat.com>
Date: Wed, 10 Feb 2010 12:08:45 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/7 -mm] oom: filter tasks not sharing the same cpuset
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100227590.8001@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002100227590.8001@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 11:32 AM, David Rientjes wrote:
> Tasks that do not share the same set of allowed nodes with the task that
> triggered the oom should not be considered as candidates for oom kill.
>
> Tasks in other cpusets with a disjoint set of mems would be unfairly
> penalized otherwise because of oom conditions elsewhere; an extreme
> example could unfairly kill all other applications on the system if a
> single task in a user's cpuset sets itself to OOM_DISABLE and then uses
> more memory than allowed.
>
> Killing tasks outside of current's cpuset rarely would free memory for
> current anyway.
>
> Signed-off-by: David Rientjes<rientjes@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
