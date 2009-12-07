Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZLGKsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZLGKsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZLGKsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:48:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:52553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZLGKsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:48:07 -0500
Message-ID: <4B1CDD79.3000004@kernel.org>
Date: Mon, 07 Dec 2009 19:48:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Subject: Re: [PATCH 16/19] workqueue: reimplement workqueue flushing using
 color coded works
References: <1258692407-8985-1-git-send-email-tj@kernel.org>	 <1258692407-8985-17-git-send-email-tj@kernel.org>	 <1259927181.17907.98.camel@laptop>  <4B196610.7090101@kernel.org>	 <1260175562.8223.1204.camel@laptop>  <4B1CDB83.2000600@kernel.org> <1260182549.8223.1463.camel@laptop>
In-Reply-To: <1260182549.8223.1463.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/07/2009 07:42 PM, Peter Zijlstra wrote:
> Currently the normal 140 priority ones.

Ah... okay.  In that case, the only way I can think of now is to walk
the whole busy worklist (new implementation knows this) and bump up
the priority of the all the previous works.

Thanks.

-- 
tejun
