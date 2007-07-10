Return-Path: <linux-kernel-owner+w=401wt.eu-S1763994AbXGJJEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763994AbXGJJEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763862AbXGJJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:04:36 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:32336 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763853AbXGJJEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:04:35 -0400
Date: Tue, 10 Jul 2007 11:04:47 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
Message-ID: <20070710110447.0f63baf3@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46934821.5020409@gmail.com>
References: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
	<46931495.4050605@gmail.com>
	<20070710102857.15a57337@gondolin.boeblingen.de.ibm.com>
	<46934821.5020409@gmail.com>
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

On Tue, 10 Jul 2007 17:49:37 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> What I was trying to say was that suicide and murder could be done the
> same way from the driver's POV or am I misunderstanding?

Do you mean a device unregistering itself from its attribute vs. a
device unregistering another device from its attribute?

> 
> > A general immediate disconnect of the buffers (which will be handled in
> > a second pass) would be great, but doesn't sound easy.
> 
> I haven't thought too hard about actual implementation but it's pretty
> specific case.  If doing things in generic manner is difficult, there
> are plenty of shortcuts to choose from, I think.

The "second pass" approach where the store method calls the sysfs core
or sets a flag or whatever sounds doable, but I'm not sure how general
we can get. Maybe for all store methods that just trigger an action.
