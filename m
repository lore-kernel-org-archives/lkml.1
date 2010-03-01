Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0CAQK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:10:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:52202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab0CAQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:10:28 -0500
Message-ID: <4B8BE91B.9090009@kernel.org>
Date: Tue, 02 Mar 2010 01:19:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 16/43] workqueue: kill cpu_populated_map
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-17-git-send-email-tj@kernel.org> <20100228160005.GA16144@redhat.com> <4B8BDE02.1050208@kernel.org> <20100301155018.GA12031@redhat.com>
In-Reply-To: <20100301155018.GA12031@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 16:08:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/02/2010 12:50 AM, Oleg Nesterov wrote:
> Hmm. not sure I understand... but before this patch the code was OK.
> cpu_maps_update_begin() in create/destroy protected us from the races
> with hotplug.

Right I've missed that completely for some reason.  I'll fix it up.

Thanks for reviewing.

-- 
tejun
