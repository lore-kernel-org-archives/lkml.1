Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYIERpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYIERpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYIERpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:45:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857AbYIERp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:45:29 -0400
Date: Fri, 5 Sep 2008 10:45:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alex Williamson <alex.williamson@hp.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jouni.malinen@atheros.com
Subject: Re: [GIT]: Networking
In-Reply-To: <1220627292.7260.3.camel@2710p.home>
Message-ID: <alpine.LFD.1.10.0809051039070.3117@nehalem.linux-foundation.org>
References: <20080827.164649.87042354.davem@davemloft.net> <1220627292.7260.3.camel@2710p.home>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Sep 2008, Alex Williamson wrote:

> On Wed, 2008-08-27 at 16:46 -0700, David Miller wrote:
> 
> > 22) Two mac80211 bug fixes from Jouni Malinen:
> >     a) Use IWEVCUSTOM so that we don't hit the 256 byte limit that
> >        IWEVASSOCREQIE has
> 
> This one breaks wireless with 32bit userspace/64bit kernel.  Bisected
> back to changeset 087d833e5a9f67ba933cb32eaf5a2279c1a5b47c:
> 
> mac80211: Use IWEVASSOCREQIE instead of IWEVCUSTOM

Grr. I'd love to say "I told you so", and write another rant about -rc 
series patches. But I'm too lazy, so people - please mentally insert my 
standard rant here.

David/Jouni - just revert it?

		Linus
