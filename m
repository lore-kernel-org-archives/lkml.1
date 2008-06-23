Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYFWTxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYFWTxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbYFWTxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:53:45 -0400
Received: from ns.theshore.net ([67.18.92.50]:42059 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbYFWTxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:53:45 -0400
Message-ID: <485FFF41.3000603@theshore.net>
Date: Mon, 23 Jun 2008 15:53:37 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: adam radford <aradford@gmail.com>
CC: linux-kernel@vger.kernel.org, xen devel <xen-devel@lists.xensource.com>
Subject: Re: ext3 directory corruption under Xen
References: <485FCC25.7090401@theshore.net> <b1bc6a000806231213p162cea21y37ed9ec1d3bb39fd@mail.gmail.com>
In-Reply-To: <b1bc6a000806231213p162cea21y37ed9ec1d3bb39fd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adam radford wrote:
> On Mon, Jun 23, 2008 at 9:15 AM, Christopher S. Aker <caker@theshore.net> wrote:
> 
>> It's happened on a number of different hosts, all of the same hardware and
>> software configuration (Xen 3.2 64bit, 32bit pae dom0, 32bit pae domUs.  LVM
>> backend with 3ware hardware RAID-1).
 >
> A driver patch for older kernels including XenServer-4.1 is available here:
> 
> http://www.3ware.com/KB/article.aspx?id=15243&cNode=6I1C6S

Thanks, but unfortunately, from that link:

"3ware 9000 series controllers are not affected by this issue."

... which is what we're using.  This problem only appeared after 
rebooting these machines into Xen.  Some of affected boxes even ran 
2.6.18 (non Xen) for awhile without any problems.

-Chris

