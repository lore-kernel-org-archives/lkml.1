Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbXFTPKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbXFTPKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXFTPKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:10:05 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:53200 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbXFTPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:10:03 -0400
Message-ID: <46794343.3080204@s5r6.in-berlin.de>
Date: Wed, 20 Jun 2007 17:09:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Greg K-H <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, "; david@lang.hm" <david@lang.hm>,
       David Miller <davem@davemloft.net>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more parallelism
 control
References: <1182373258.30574.30.camel@caritas-dev.intel.com>
In-Reply-To: <1182373258.30574.30.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This is a new version of multithreaded probing patch, with more
> parallelism control added.

Thanks.  (I'd like to try it out but will probably be busy with other
stuff during the next few weeks.)

...
> A field named "probe_queue_no" is added to "struct device", which

I'd call it probe_queue_number or maybe probe_queue_id.  The term "no"
is ambiguous.

> indicates probing queue No. on which the probing of the device will be
> done. The subsystem can control the parallelism through this field.

Is the queue number kernel-global or per subsystem?

...
> + * schedule_probe - schedule a probing to be done later
> + * @probe_queue_no: probing queue No. on which the probing will be done
> + * @probe: probing infromation include probing function and parameter
                      ^^^^^^^^^^^
typo: information
-- 
Stefan Richter
-=====-=-=== -==- =-=--
http://arcgraph.de/sr/
