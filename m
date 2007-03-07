Return-Path: <linux-kernel-owner+w=401wt.eu-S1161081AbXCGHNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161081AbXCGHNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161092AbXCGHNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:13:55 -0500
Received: from netcore.fi ([193.94.160.1]:35416 "EHLO netcore.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161081AbXCGHNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:13:54 -0500
X-Greylist: delayed 1689 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 02:13:53 EST
Date: Wed, 7 Mar 2007 08:42:39 +0200 (EET)
From: Pekka Savola <pekkas@netcore.fi>
To: Chris Friesen <cfriesen@nortel.com>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, ak@muc.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, rusty@rustcorp.com.au,
       ian.pratt@xensource.com, Christian.Limpach@cl.cam.ac.uk,
       netdev@vger.kernel.org, jeff@garzik.org
Subject: Re: [RFC] ARP notify option
In-Reply-To: <45EDDA8F.5060106@nortel.com>
Message-ID: <Pine.LNX.4.64.0703070838010.8567@netcore.fi>
References: <20070301164214.4a40bc59@freekitty> <45E7764A.7000100@goop.org>
 <20070301173030.754514ec@freekitty> <20070305.203536.92584097.davem@davemloft.net>
 <20070306105132.52c77491@freekitty> <45EDDA8F.5060106@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Chris Friesen wrote:
> Stephen Hemminger wrote:
>>  +arp_notify - BOOLEAN
>>  +	Define mode for notification of address and device changes.
>>  +	0 - (default): do nothing
>>  +	1 - Generate gratuitous arp replies when device is brought up
>>  +	    or hardware address changes.
>
> Did you consider using gratuitous arp requests instead?  I remember reading 
> about some hardware that updated its arp cache on gratuitous requests but not 
> gratuitous replies.

You might be interested in taking a look at:

http://tools.ietf.org/id/draft-cheshire-ipv4-acd

There has been some follow-up discussion on this in the thread 
starting at:

http://www1.ietf.org/mail-archive/web/int-area/current/msg00611.html

In particular, you may be interested in this comment about ARP 
request and ARP reply for gratuitous ARP:

http://www1.ietf.org/mail-archive/web/int-area/current/msg00669.html

-- 
Pekka Savola                 "You each name yourselves king, yet the
Netcore Oy                    kingdom bleeds."
Systems. Networks. Security. -- George R.R. Martin: A Clash of Kings
