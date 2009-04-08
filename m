Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbZDHCsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbZDHCsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZDHCry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:47:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbZDHCrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:47:53 -0400
From: Ben Hutchings <bhutchings@solarflare.com>
To: Shen Feng <shen@cn.fujitsu.com>
Cc: davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49DC091C.6070708@cn.fujitsu.com>
References: <49DC091C.6070708@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Solarflare Communications
Date: Wed, 08 Apr 2009 03:47:43 +0100
Message-Id: <1239158863.11534.52.camel@deadeye.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: bhutchings@solarflare.com
Subject: Re: [PATCH] IPv4/IPv6: update sysctl files
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 02:39 +0000, Shen Feng wrote:
> Now the following sysctl files in /proc/sys/net/ipv4 are used by
> both IPv4 and IPv6.
> tcp_mem  tcp_rmem  tcp_wmem
> udp_mem  udp_rmem_min  udp_wmem_min
> Putting them in /proc/sys/net/ipv4 is not a good choice.
[...]

But this is part of the ABI to userland.  You cannot remove sysctl files
without long advance notice documented in feature-removal-schedule.txt
(if at all).

If it is possible to add the paths
/proc/sys/net/{tcp,udp} while retaining aliases under /proc/sys/net/ipv4
then that might be a workable solution.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.
