Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbXGJKuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbXGJKuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbXGJKuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:50:01 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:14269 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433AbXGJKuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:50:00 -0400
Date: Tue, 10 Jul 2007 12:50:12 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
Message-ID: <20070710125012.17dcba32@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46934DC7.1020104@gmail.com>
References: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
	<46931495.4050605@gmail.com>
	<20070710102857.15a57337@gondolin.boeblingen.de.ibm.com>
	<46934821.5020409@gmail.com>
	<20070710110447.0f63baf3@gondolin.boeblingen.de.ibm.com>
	<46934DC7.1020104@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 18:13:43 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> More like "device unregistering itself from its attribute" vs. "whatever
> else".

Ah, ok. I don't think we can make those the same, but "trigger an
action and return" vs. "whatever else" may be possible.

> 
> >>> A general immediate disconnect of the buffers (which will be handled in
> >>> a second pass) would be great, but doesn't sound easy.
> >> I haven't thought too hard about actual implementation but it's pretty
> >> specific case.  If doing things in generic manner is difficult, there
> >> are plenty of shortcuts to choose from, I think.
> > 
> > The "second pass" approach where the store method calls the sysfs core
> > or sets a flag or whatever sounds doable, but I'm not sure how general
> > we can get. Maybe for all store methods that just trigger an action.
> 
> Hmm... I'll give it a shot in a few days.

Cool. I'd try myself, but I'm currently a bit short on time :)
