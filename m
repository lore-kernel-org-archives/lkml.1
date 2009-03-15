Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbZCOVhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbZCOVhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZCOVgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:36:49 -0400
Received: from bu3sch.de ([62.75.166.246]:37501 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbZCOVgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:36:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Date: Sun, 15 Mar 2009 22:35:15 +0100
User-Agent: KMail/1.9.9
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, Jiri Slaby <jirislaby@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>,
       ath5k-devel@venema.h4ckr.net, davem@davemloft.net
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com> <200903152227.16676.s.L-H@gmx.de>
In-Reply-To: <200903152227.16676.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152235.15914.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 22:27:13 Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Mittwoch, 7. Januar 2009, Jiri Slaby wrote:
> > On 01/07/2009 02:51 PM, Jiri Slaby wrote:
> > > Dhaval Giani wrote:
> > >> I see this on current git. Not sure how to reproduce it, has happened on
> > >> two random occasions. At both times, I was not connected to a wireless
> > >> network, but to wired networks.
> > >>
> > >> ------------[ cut here ]------------
> > >> WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0x7f/0x559

I also see this triggering frequently on b43.
I'm not quite sure why it happens.

> Sometimes even the firmware crashes and gets reloaded continously.

Nah, that's most likely a separate bug.

-- 
Greetings, Michael.
