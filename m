Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbYBSCpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbYBSCpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbYBSCpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:45:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYBSCpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:45:38 -0500
Date: Tue, 19 Feb 2008 02:45:33 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Ric Wheeler <ric@emc.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080219024533.GC4066@agk.fab.redhat.com>
Mail-Followup-To: Ric Wheeler <ric@emc.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	device-mapper development <dm-devel@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <47B98D8A.7090506@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B98D8A.7090506@emc.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 08:52:10AM -0500, Ric Wheeler wrote:
> I understand that. Most of the time, dm or md devices are composed of 
> uniform components which will uniformly support (or not) the cache flush 
> commands used by barriers.
 
As a dm developer, it's "almost none of the time" because trivial
configurations aren't the ones that require lots of testing effort.

Let's stop arguing over "most of the time":-)

As Andi points out, there are certainly enough real-world users of
"single linear or crypt target using one physical device" for it to be
worth our supporting it.

Alasdair
-- 
agk@redhat.com
