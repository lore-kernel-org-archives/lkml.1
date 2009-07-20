Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZGTQTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZGTQTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZGTQTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:19:04 -0400
Received: from mail-01.cse.ucsc.edu ([128.114.48.32]:43429 "EHLO
	mail-01.cse.ucsc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZGTQTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:19:04 -0400
Date: Mon, 20 Jul 2009 09:19:00 -0700 (PDT)
From: Noah Watkins <jayhawk@soe.ucsc.edu>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <1198385022.260301248106740802.JavaMail.root@mail-01.cse.ucsc.edu>
In-Reply-To: <1279186756.260191248106587108.JavaMail.root@mail-01.cse.ucsc.edu>
Subject: Re: regression: wireless authentication
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [98.234.142.166]
X-Mailer: Zimbra 5.0.15_GA_2851.RHEL5_64 (ZimbraWebClient - [unknown] (Linux)/5.0.15_GA_2851.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest version I've tried that works fine is Linus' 2.6.31-rc3
with the latest commit being:

commit 35b5c55fee08e6e4001ba98060a2d0b82f70b5f4
Merge: e9e961c... b2dde6a...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 15 10:29:09 2009 -0700

I encountered the problem I described when I booted:

2.6.31-rc3-next-20090716

-n

----- Original Message -----
From: "John W. Linville" <linville@tuxdriver.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "Noah Watkins" <jayhawk@soe.ucsc.edu>, linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Sent: Monday, July 20, 2009 7:59:34 AM GMT -08:00 US/Canada Pacific
Subject: Re: regression: wireless authentication

On Fri, Jul 17, 2009 at 02:10:47PM +1000, Stephen Rothwell wrote:
> Hi Noah,
> 
> Lets cc some people who may be able to help ...
> 
> On Thu, 16 Jul 2009 20:57:06 -0700 Noah Watkins <jayhawk@soe.ucsc.edu> wrote:
> >
> > With 2.6.31-rc3-next-20090716 all wireless access points are detected, but
> > authentication fails. I haven't verified on an access point w/o WPA.
> > 
> > 2.6.31-rc3 functions fine. I haven't been able to complete a bisect yet.
> > 
> > 05:01.0 Network controller: Atheros Communications Inc. AR5008 Wireless Network
> > Adapter (rev 01)

Odd...have you (i.e. Noah) been using -next trees all along?  What was
the last previous one that worked?  I didn't push anything out for
-next to pick-up all last week...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
