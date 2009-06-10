Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbZFJJso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbZFJJso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZFJJs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:48:26 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59082 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZFJJsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:48:24 -0400
Date: Wed, 10 Jun 2009 11:48:09 +0200
From: Hans-Joachim Picht <hans@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 05/38] s390: hibernation support for s390
Message-ID: <20090610114809.2c96d243@blc4eb509856389.ibm.com>
In-Reply-To: <20090609195903.GB1388@ucw.cz>
References: <20090604161847.513682672@de.ibm.com>
	<20090604161900.659762303@de.ibm.com>
	<20090608064451.GD1444@ucw.cz>
	<20090609153402.58e6b841@blc4eb509856389.ibm.com>
	<20090609195903.GB1388@ucw.cz>
Organization: IBM Deutschland Research & Development GmbH
X-Mailer: Claws Mail 3.7.0cvs74 (GTK+ 2.16.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 21:59:03 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> > > > +/*
> > > > + * save CPU registers before creating a hibernation image and
> > > > before
> > > > + * restoring the memory state from it
> > > > + */
> > > > +void save_processor_state(void)
> > > > +{
> > > > +}
> > > > +
> > > > +/*
> > > > + * restore the contents of CPU registers
> > > > + */
> > > > +void restore_processor_state(void)
> > > > +{
> > > > +}
> > > 
> > > ...and explaining why the functions can be emmpty would be nice.
> > 
> > I integrated the code for this in the assembly backend in the
> > swsusp_arch_suspend & swsusp_arch_resume functions.
> 
> I guessed so. Maybe it is worth a comment?

Sure ;-)
