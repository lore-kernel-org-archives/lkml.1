Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZFWBN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZFWBN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZFWBNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:13:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51522 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbZFWBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:13:49 -0400
Subject: Re: Regression: ppc powerstation boot hang caused by slab
 initialisation code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1245717131.4017.19.camel@pasglop>
References: <1245708635.17035.6.camel@mulgrave.site>
	 <1245709633.20062.13.camel@pasglop>
	 <1245710457.17035.9.camel@mulgrave.site>  <1245711062.4017.1.camel@pasglop>
	 <1245712892.17035.39.camel@mulgrave.site>
	 <1245717131.4017.19.camel@pasglop>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 20:10:40 -0500
Message-Id: <1245719440.17035.41.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 10:32 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-22 at 18:21 -0500, James Bottomley wrote:
> > On Tue, 2009-06-23 at 08:51 +1000, Benjamin Herrenschmidt wrote:
> > > Ah, I notice you use SLAB, that's the second report of hangs with it due to
> > > the changes. You can try SLUB while I'm looking, might help.
> > 
> > Yes, switching to slub fixes it ... although given that the identified
> > problem commit is a slab one, that's understandable ...
> 
> Patch on its way (separate thread).

Got it .. just compiling now; changing the allocator seems to require a
rebuild of about every file.

>  BTW. Any reason why you don't have
> IRQSTACKs ? We really need to make that not an option....

That would probably be because I got it from the original debian OS, I
think.  I tend to use OS provided .configs as the basis for my changes.

James

