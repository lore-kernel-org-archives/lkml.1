Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbYHZTFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbYHZTFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbYHZTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:05:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38751 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304AbYHZTFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:05:17 -0400
Date: Tue, 26 Aug 2008 20:05:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [2.6.27-rc4-git5] ipv4: sysctl fixes causes "cannot open
	/proc/sys/net/ipv4/route/flush"
Message-ID: <20080826190515.GY28946@ZenIV.linux.org.uk>
References: <48B43562.20602@numericable.fr> <48B43A0A.5060406@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B43A0A.5060406@numericable.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 07:14:50PM +0200, Rufus & Azrael wrote:
> Rufus & Azrael wrote:
>> Hi Al and David,
>>
>>
>> After building the fresh 2.6.27-rc4-git5 kernel with your patch in commit 
>> 2f4520d35d89ca6c5cd129c38e3b11f0283b7d1b, I have this error on boot :
>>
>>> Cannot open "/proc/sys/net/ipv4/route/flush"
>> but networking works fine.
>>
>> Do I modify something in my sysctl.conf file ? (see attached).
>>
>> Thanks for your explanations,
>>
>> Regards.
>>
>>
>>
> Ok, perhaps is it a regression of your previous patches in commits 
> eeb61f719c00c626115852bbc91189dc3011a844 and 
> 6f9f489a4eeaa3c8a8618e078a5270d2c4872b67 (
> net: missing bits of net-namespace / sysctl)

I'm just about to fall down at the moment, will look into that once I get
some sleep.  In the meanwhile, .config might be useful...
