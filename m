Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZKJRxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZKJRxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZKJRxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:53:41 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:4745 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZKJRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:53:40 -0500
Subject: Re: sunrpc port allocation and IANA reserved list
From: Ben Hutchings <bhutchings@solarflare.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF9A63B.6010101@nortel.com>
References: <4AF9A63B.6010101@nortel.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 10 Nov 2009 17:53:43 +0000
Message-Id: <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 17:53:46.0288 (UTC) FILETIME=[C0026300:01CA622E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17000.004
X-TM-AS-Result: No--21.250900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 11:43 -0600, Chris Friesen wrote:
> By default sunrpc ports are allocated at random in the range 665-1023U.
>  However, there are many ports within this range which have been
> reserved by the IANA (and others like port 921 which are not formally
> reserved but are "well-known").
> 
> Given that a userspace application can be stopped and restarted at any
> time, and a sunrpc registration can happen at any time, what is the
> expected mechanism to prevent the kernel from allocating a port for use
> by sunrpc that reserved or well-known?
> 
> Apparently Redhat and Debian have distro-specific ways of dealing with
> this, but is there a standard solution?  Should there be?
> 
> The current setup seems suboptimal.

I believe both RH and Debian are using the same implementation:
<http://cyberelk.net/tim/software/portreserve/>.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

