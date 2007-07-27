Return-Path: <linux-kernel-owner+w=401wt.eu-S938623AbXG1AKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938623AbXG1AKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765012AbXG1AK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:10:27 -0400
Received: from s36.avahost.net ([74.53.95.194]:58092 "EHLO s36.avahost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762241AbXG1AK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:10:26 -0400
X-Greylist: delayed 55612 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 20:10:26 EDT
Message-ID: <46A9B029.1030106@katalix.com>
Date: Fri, 27 Jul 2007 09:43:21 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@daveloft.net
Subject: Re: [PATCH] misannotation in pppol2tp
References: <E1IE6Iv-0005Lj-N2@ZenIV.linux.org.uk>
In-Reply-To: <E1IE6Iv-0005Lj-N2@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PopBeforeSMTPSenders: careers@katalix.com,forums@katalix.com,info@katalix.com,jchapman@katalix.com,katalixc,lists@katalix.com,orders@katalix.com,sales@katalix.com,support@katalix.com,webmaster@katalix.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s36.avahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - katalix.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Address of auto variable is not a userland pointer.  A good thing, too,
> since if pppol2tp_tunnel_getsockopt() would _really_ get a userland pointer
> as argument, it would be an instant roothole...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: James Chapman <jchapman@katalix.com>

Thanks Al.

-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

