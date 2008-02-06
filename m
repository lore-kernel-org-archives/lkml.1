Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYBFTIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYBFTIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbYBFTIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:08:12 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:21268 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbYBFTIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:08:10 -0500
X-Greylist: delayed 2418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 14:08:10 EST
Message-ID: <47A9FC16.3070803@chelsio.com>
Date: Wed, 06 Feb 2008 10:27:34 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH 2.6.25] cxgb3: Handle ARP completions that mark neighbors
 stale.
References: <20080206180519.4680.34741.stgit@dell3.ogc.int>
In-Reply-To: <20080206180519.4680.34741.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2008 18:26:35.0203 (UTC) FILETIME=[CDF5B930:01C868ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> cxgb3: Handle ARP completions that mark neighbors stale.
>
> When ARP completes due to a request rather than a reply the neighbor is
> marked NUD_STALE instead of reachable (see arp_process()).  The handler
> for the resulting netevent needs to check also for NUD_STALE.
>
> Failure to use the arp entry can cause RDMA connection failures.
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>   

Acked-by: Divy Le Ray <divy@chelsio.com>

Divy
