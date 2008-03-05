Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYCERbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYCERbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYCERaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:30:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36510 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYCERat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:30:49 -0500
Date: Wed, 5 Mar 2008 18:32:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305173212.GA12629@one.firstfloor.org>
References: <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx> <20080304172918.GA27332@one.firstfloor.org> <20080304183032.17084e39@mjolnir.drzeus.cx> <20080304174315.GB27332@one.firstfloor.org> <20080304190446.775165e3@mjolnir.drzeus.cx> <20080304183406.GC27332@one.firstfloor.org> <20080305070454.3df78593@mjolnir.drzeus.cx> <20080305154856.GC553@one.firstfloor.org> <20080305175339.2059226b@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305175339.2059226b@mjolnir.drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I don't use jiffies in the idle exit path, only the entry path.

On entry jiffies should be always uptodate. Only on exit there
is the small code window where it isn't.

> > Action: Test if it works
> > Check: If test succeeded exit 
> > Otherwise: Restart at Start
> > 
> 
> Now you're just being a smart-ass. :)

Well you asked for pseudo code ...

-Andi
