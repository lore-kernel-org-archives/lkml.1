Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXL2Tgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXL2Tgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 14:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXL2TgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 14:36:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:40153 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751865AbXL2TgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:36:16 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+WjqNV5T+WPrlRb7UxkV3zxMH5emAu/Mml/P45XW
	PsT7sAR39nHcai
Date: Sat, 29 Dec 2007 20:36:11 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: Top 9 kernel oopses/warnings for the week of December 29th,
	2007
Message-ID: <20071229193611.GA5609@atjola.homenet>
References: <477630CF.5070609@linux.intel.com> <alpine.LFD.0.9999.0712291116190.2778@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.9999.0712291116190.2778@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.12.29 11:18:18 -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 29 Dec 2007, Arjan van de Ven wrote:
> >
> > It has been a quiet week due to the holidays, only 55 oops traces
> > have been collected.
> 
> This would be more useful if it was more readable. As it is, you seem to 
> have some formatting errors in your automation, where the things are 
> incorrectly grouped:
> 
> > Rank 1: sysctl_head_finish
> > 	sysctl table check failed
> > 	Reported 7 times
> > 	Only reported for the proprietary madwifi driver
> > 	More info: http://www.kerneloops.org/search.php?search=sysctl_head_finish
> > 	Rank 2: __ieee80211_rx
> > 	Warning at net/mac80211/rx.c:1672
> 
> ie notice how that "Rank 2" got reported as if it was part of the "Rank 1" 
> issue. 

Shows up correctly here. Random guess is that your MUA treats tabs like
spaces when it sees format=flowed. The lines between the different ranks
weren't empty but had a single tab. And for whatever reason (I don't see
any trailing spaces), Arjan's mail had a format=flowed header.

AFAIK, only SPACE CRLF is valid for line-continuation with
format=flowed, not TAB CRLF.  So the above formatting would be the
result of a pointless format=flowed header meeting a MUA that was too
eager searching for line continuations.

Björn
