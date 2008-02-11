Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbYBKQJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbYBKQJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbYBKQJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:09:30 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51993 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbYBKQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:09:29 -0500
Message-ID: <47B07335.5090709@garzik.org>
Date: Mon, 11 Feb 2008 11:09:25 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH 2.6.25] cxgb3: Handle ARP completions that mark neighbors
 stale.
References: <20080206180519.4680.34741.stgit@dell3.ogc.int>
In-Reply-To: <20080206180519.4680.34741.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
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

applied


