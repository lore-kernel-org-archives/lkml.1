Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXKESHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXKESHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXKESHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:07:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:62174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbXKESHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:07:42 -0500
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
From: Kay Sievers <kay.sievers@vrfy.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20071105184350.0a1cd957@gondolin.boeblingen.de.ibm.com>
References: <20071102235758.GA9803@kroah.com>
	 <1194047972-9850-34-git-send-email-gregkh@suse.de>
	 <20071105134203.1c078136@gondolin.boeblingen.de.ibm.com>
	 <1194279812.6771.11.camel@lov.site> <20071105171133.GD12843@suse.de>
	 <1194283540.2174.8.camel@lov.site>
	 <20071105184350.0a1cd957@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 19:07:50 +0100
Message-Id: <1194286070.2174.14.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18f2gGvj1Y9rII+g8ZVq3QG0CNSuP0ocZvn+45
 3SGyr3hE2AWn0b2lKBJ8nO/7w8RipZK/bgX/y5RY1qOdXf73N6
 MdpSZCilpZsmnZbFnhmMlZvzNx4hMgS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-05 at 18:43 +0100, Cornelia Huck wrote:
> On Mon, 05 Nov 2007 18:25:40 +0100,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > > > That should usually be done by default attributes assigned to the ktype.
> > > > Do you have a good use case, where people need to create such attributes
> > > > individually instead?
> > > 
> > > The s390 code that was converted to use kobj_attributes :)
> > > 
> > > These look very useful, I'll go add them to the series unless Kay really
> > > objects.
> > 
> > I just want to hear a good reason to create attributes individually. :)
> > Especially in conjunction with kobject_register(), these attributes are
> > not available at uevent time, which is really really bad.
> > 
> > Default attributes just work fine, and have the proper error handling
> > built-in. Offering special functions for it, may just encourage people
> > to continue this "broken" way of creating attributes.
> 
> But where should I specify those default attributes?
> kset_create_and_register() sets the ktype to kset_ktype...

Do you need to create attributes at a kset itself, not the kobjects that
belong to the kset?

Kay

