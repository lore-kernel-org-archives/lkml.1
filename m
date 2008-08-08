Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYHHBfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYHHBfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHHBfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:35:08 -0400
Received: from main.gmane.org ([80.91.229.2]:55209 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYHHBfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:35:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Daniel Ng <daniel_ng11@lycos.com>
Subject: IPv4 Unnumbered Multicast?
Date: Fri, 8 Aug 2008 01:28:20 +0000 (UTC)
Message-ID: <loom.20080808T011604-359@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 124.190.96.129 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Would someone please tell me if the latest kernel is able to handle Multicast 
IGMP Joins and sending of Multicast packets on multiple Unnumbered PPP links?

As you probably know, for IPv4, Unnumbered PPP links 'share' the IP address of 
another interface on the same machine. Therefore, you could potentially have 
multiple PPP links on one machine, all with exactly the same local IP address. 
We might want any number of these PPP interfaces to join the same Multicast 
Group.

Can we multicast send/receive in this scenario? The setsockopt() 
IP_MULTICAST_IF and IP_ADD_MEMBERSHIP options only seem to distinguish 
interfaces by their IP address.

Cheers,
Daniel





