Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYHRKyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYHRKyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYHRKyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:54:15 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:35717 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYHRKyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:54:13 -0400
In-Reply-To: <e7d8f83e0808171711y3a60b0d2s4e4770bf4c362bc9@mail.gmail.com>
To: "Peter Dolding" <oiaohm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon	access
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Mon, 18 Aug 2008 11:54:18 +0100
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 11:53:16,
	Serialize complete at 18/08/2008 11:53:16
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818105417.1EE932FE865@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

malware-list-bounces@dmesg.printk.net wrote on 2008-08-18 01:11:24:

> In answer to the small enough set of files idea.   The simple issue is
> that one time cost of black list scanning gets longer and longer and
> longer as the black list gets longer and longer and longer.   Sooner
> or latter its going to be longer than the amount of time people are
> prepared to wait for a file to be approved and longer than the time
> taken to white list scan the file by a large margin.  It is already
> longer by a large margin to white list scanning.    CPU sizes not
> expanding as fast on Linux kind brings the black list o heck problem
> sooner.   Lot of anti-virus black lists are embeding white lists
> methods so they can operate now inside the time window.   The wall is
> coming and its simply not avoidable all they are currently doing is
> just stopping themselves from going splat into it.  White list methods
> will have to become more dominate one day there is no other path
> forward for scanning content.

The problem with white-lists is who gets to decide what's on them:

a) The end-user: Easy to get around - a social engineering attack.
        The problem is if you make all the good applications the
        user downloads appear identical to any random malware they 
        download, the end-users will treat them the same.

b) The network administrator: Often doesn't exist (e.g. home users), but
        even when they do exist, they are often too over-worked to 
        handle a white-listing solution. For example Windows provides 
        white-listing in policies (AFAIK), but still there is a market
        for AV software.
        The admin probably ends up authorizing anything the end-users 
want.
                (Thus leading to the same problems as a)...)

c) The White-listing software company: Now has to maintain a perfect 
database
        of known-good software, without letting in any malware.
        Also problems with edge-cases such as adware.
        Also needs some way of handling private software, and 
self-compiled software.
                (which probably leads to a) or b)...)

d) Third-party: All the problems of c) with more trust issues, plus
        iphone-ish lock-in problems.

The other problem that I can see is that white-list scanners have to be
much more exact on the matching (either checksums or signatures), as the
malware authors will be trying to look-like authorized software.

black-list scanners can afford heuristic detection, because good-software 
authors
aren't trying to look like malware.

-- 
Douglas Leeder

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

