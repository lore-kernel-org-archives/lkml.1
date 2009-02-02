Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZBBVN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZBBVN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZBBVNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:13:18 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:57523 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZBBVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:13:17 -0500
Message-ID: <498761E7.3080006@walrond.org>
Date: Mon, 02 Feb 2009 21:13:11 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jengelh@medozas.de, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28 headers break kbd and net-tools userspace builds
References: <20090128.122924.106238702.davem@davemloft.net>	<alpine.LSU.2.00.0901300510310.22910@fbirervta.pbzchgretzou.qr>	<4986CC6D.4090904@walrond.org> <20090202.120507.152093960.davem@davemloft.net>
In-Reply-To: <20090202.120507.152093960.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>
> There isn't anything we can really do about these cases.
>
> No matter what we do, we break the userland build in one way or
> another.
>   
What exactly is the purpose of the kernel headers? Are there some 
definitions in the kernel headers that will never be available from 
glibc? Is it perhaps possible to work towards exporting kernel headers 
for the sole purpose of building glibc, and all other packages should be 
able to build against glibc's headers?

Andrew Walrond
