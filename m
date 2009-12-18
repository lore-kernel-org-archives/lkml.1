Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZLROMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZLROMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZLROMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:12:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZLROMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:12:33 -0500
Message-ID: <4B2B8DC6.7010506@redhat.com>
Date: Fri, 18 Dec 2009 09:12:22 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091211164651.036f5340@annuminas.surriel.com> <4B2B85C3.5040409@redhat.com>
In-Reply-To: <4B2B85C3.5040409@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 08:38 AM, Avi Kivity wrote:

>> + /* Number of processes running page reclaim code on this zone. */
>> + atomic_t concurrent_reclaimers;
>> + wait_queue_head_t reclaim_wait;
>> +
>
> Counting semaphore?

I don't see a safe way to adjust a counting semaphore
through /proc/sys.

-- 
All rights reversed.
