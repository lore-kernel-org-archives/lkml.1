Return-Path: <linux-kernel-owner+w=401wt.eu-S1161498AbXDSN1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161498AbXDSN1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161499AbXDSN1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:27:05 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:40145 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161498AbXDSN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:27:03 -0400
Date: Thu, 19 Apr 2007 15:29:41 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070419152941.7c4b7ff2@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46264201.3060007@gmail.com>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
	<20070417184110.GJ10619@htj.dyndns.org>
	<20070418170652.7bee0952@gondolin.boeblingen.de.ibm.com>
	<46264201.3060007@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:06:25 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Heh heh, I'm amazed it actually works.  Agreed that the list walking
> isn't pretty but adding completion to each kobject still feels like too
> much of overhead just for release waiting.  Any better ideas?

Not really. But I'm more in favour on adding a new field than on adding
complicated code. (Although, the whole device infrastructure wouldn't
fare bad with some diet...)
