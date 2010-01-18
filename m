Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487Ab0ARQPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0ARQPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388Ab0ARQPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:15:18 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57098 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0ARQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:15:16 -0500
Message-ID: <4B5488AC.3040208@s5r6.in-berlin.de>
Date: Mon, 18 Jan 2010 17:13:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCHSET] concurrency managed workqueue, take#3
References: <1263776272-382-1-git-send-email-tj@kernel.org>
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> slow-work is probably the largest chunk which can be replaced by cmwq
> but as shown in the libata case small conversions can bring noticeable
> benefits and there are other places which have had to deal with
> similar limitations.

I for one as driver programmer am keen on cmwq.  It would help me fix a
lack of parallelism in firewire (target probe/ reconnect/ removal in the
storage driver).  I can implement what I have in mind with slow-work too
but cmwq would take less effort and LOC.
-- 
Stefan Richter
-=====-==-=- ---= =--=-
http://arcgraph.de/sr/
