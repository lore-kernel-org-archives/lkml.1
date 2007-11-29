Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbXK2Rwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbXK2Rwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761915AbXK2RwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:52:21 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:1477 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763431AbXK2RwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:52:20 -0500
Date: Thu, 29 Nov 2007 18:52:17 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129185217.7255f8fb@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291152380.4712-100000@iolanthe.rowland.org>
References: <20071129172833.0203a75b@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0711291152380.4712-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 11:55:43 -0500 (EST),
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 29 Nov 2007, Cornelia Huck wrote:
> 
> > > Unfortunately kobjects don't have an owner field.  In practice this 
> > > means that it isn't possible to pin the owner of some random kobject -- 
> > > you have to know where the kobject came from or what it's embedded in.  
> > > All users of kobjects need to work this way.
> > 
> > Yeah, that is what the-patchset-I-have-to-dig-around-for does:
> > Introduce an owner field in the kobject for pinning the module. (IIRC,
> > you even did some of the patches?)
> 
> Are these two patches what you mean?  They are a little out-of-date
> now, but the main idea hasn't changed.

Yes, thanks. I had also a module-reference-count part that I need to
resurrect.
