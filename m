Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYIJDSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYIJDSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYIJDSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:18:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYIJDSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:18:09 -0400
Message-ID: <48C73C15.2000103@redhat.com>
Date: Tue, 09 Sep 2008 23:16:37 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Thierry <thierry.bultel@wanadoo.fr>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Suggested patch: Sending the FQDN when booting via DHCP
References: <48C6B3DA.3040904@wanadoo.fr>
In-Reply-To: <48C6B3DA.3040904@wanadoo.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry wrote:
> [re-sent without HTML encoding, and to the right aliases ...]
> 
> Hi all,
> 
> the following patch can be useful, in order to let the DHCP server 
> accordingly update the DNS, when booting via DHCP.
> 
> This can be useful for 2 reasons:
> 1) on small systems, the embedded filesystem may even not have udhcpd
> 2) when booting nfsroot, the nfs server does not like when udhcpd in 
> invoked, even when requested the same IP address.
> 
> Here is the patch, for 2.6.27-rc5. (Notice that it is the very first 
> time I deliver a patch for Linux, and I may
> have missed some points on the procedure, if it is the case I apologize 
> for that). What do you think about it ?
> 
> Any ideas or comments are welcome.

This should probably be a kernel command-line option, rather than a static 
config option.

-- Chris
