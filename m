Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbXJ3Rb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbXJ3Rb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJ3Rbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:31:33 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:12589 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXJ3Rbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:31:32 -0400
Date: Tue, 30 Oct 2007 18:31:12 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dirk Hohndel <hohndel@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071030165608.GA2601@linux.intel.com>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com>
	<20071029154849.GA24187@bigserver.hohndel.org>
	<20071030080742.GE4993@kernel.dk>
	<20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com>
	<20071030165608.GA2601@linux.intel.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 09:56:08 -0700,
Dirk Hohndel <hohndel@linux.intel.com> wrote:

> > > IIRC, Al recently vetoed a similar patch. As far as I'm concerned, with
> > > the correct return values, the patch then looks fine to me.
> > 
> > We need some kind of check concerning the kobject to avoid mysterious
> > errors (especially checking for the failed kobject_add() is needed).
> > Whether we want just to inform the user of the failure instead of
> > failing the function is another question.
> 
> What are you suggesting? I'd love to make the behaviour consistent everywhere
> (and am willing to go through things in order to make that happen), but what is
> the consistent behaviour that we'd want?

I'd be fine with just propagating the error after cleanup (that is what
for example the driver core usually does), but I don't know the
surrounding code well enough for a definitive answer.
