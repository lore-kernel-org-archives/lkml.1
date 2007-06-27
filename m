Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXF0P6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXF0P6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbXF0P6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:58:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbXF0P63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:58:29 -0400
Message-ID: <4682891A.2070900@redhat.com>
Date: Wed, 27 Jun 2007 11:58:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: mchan@broadcom.com, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Subject: Re: 2.6.21.x kernel panic (tg3 and nfs related)
References: <20070627101608.GQ22589@skl-net.de>
In-Reply-To: <20070627101608.GQ22589@skl-net.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2007 06:16 AM, Andre Noll wrote:
> Hi
> 
> Our nfs server recently paniced under heavy nfs load. The backtrace
> indicates that this might be a problem with the tigon3 network driver
> which drives the onboard chips of the machine.
> 
> The first crash under 2.6.21.1 happened after about 4 days of uptime, 
> 2.6.21.5 already crashed after 15 Minutes.
> 
> Screenshots of the resulting kernel panics are available at
> 
> 	http://www.systemlinux.org/~maan/shots/huangho-crash-2.6.21.1.png
> and
> 	http://www.systemlinux.org/~maan/shots/huangho-crash-2.6.21.5.png
> 

Looks the the known oops in show_mem(); patch is queued for 2.6.21.6.

But it is hard to tell when the screen shot doesn't show the whole
message...
