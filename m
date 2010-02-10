Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab0BJVJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:09:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab0BJVJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:09:47 -0500
Message-ID: <4B73206C.8090108@redhat.com>
Date: Wed, 10 Feb 2010 16:09:00 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Lubos Lunak <l.lunak@suse.cz>
CC: David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
References: <201002012302.37380.l.lunak@suse.cz> <201002040858.33046.l.lunak@suse.cz> <alpine.DEB.2.00.1002041255080.6071@chino.kir.corp.google.com> <201002102154.39771.l.lunak@suse.cz>
In-Reply-To: <201002102154.39771.l.lunak@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 03:54 PM, Lubos Lunak wrote:

>   Simply computing the cost of the whole children subtree (or a reasonable
> approximation) avoids the need for any magic numbers and gives a much better
> representation of how costly the subtree is, since, well, it is the cost
> itself.

That assumes you want to kill off that entire tree.

You will not want to do that when a web server or
database server runs out of memory, because the
goal of the OOM killer is to allow the system to
continue to run and be useful. This means keeping
the services available...

-- 
All rights reversed.
