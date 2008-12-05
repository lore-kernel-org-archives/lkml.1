Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYLERP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYLERP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYLERPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:15:47 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:34700 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYLERPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:15:47 -0500
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
From: david safford <safford@watson.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081205152318.GD10037@us.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
	 <20081203123021.GA30035@infradead.org>
	 <1228328323.2821.30.camel@localhost.localdomain>
	 <20081203182300.GA31203@infradead.org>
	 <1228342655.2821.64.camel@localhost.localdomain>
	 <20081204130949.GA18196@infradead.org>
	 <1228424014.3014.58.camel@localhost.localdomain>
	 <alpine.LRH.1.10.0812051236420.11818@tundra.namei.org>
	 <1228481810.3005.31.camel@localhost.localdomain>
	 <20081205152318.GD10037@us.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Dec 2008 12:14:35 -0500
Message-Id: <1228497275.3041.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 09:23 -0600, Serge E. Hallyn wrote:
> Quoting david safford (safford@watson.ibm.com):
> > On Fri, 2008-12-05 at 12:42 +1100, James Morris wrote:
> > > On Thu, 4 Dec 2008, david safford wrote:
> > >
> > > > These hooks were for alternate integrity modules, and since
> > > > no one else has defended them, we have to agree that they
> > > > should be replaced with direct calls.
> > >
> > > If you know of other modules which are planned to be ported to this
> > > framework, merged upstream and supported, then this would be similar to
> > > the situation when LSM was initially developed.
> > >
> > > You've previously mentioned some active projects here:
> > > http://lkml.org/lkml/2008/11/17/362
> > >
> > > Are there any definite commitments to push these upstream when the
> > > integrity framework is merged?
> > 
> > All of the projects listed in that posting were ones depending on
> > IMA, with no requirements for alternate modules. I do hope that there
> > will be other integrity modules in addition to the TPM oriented IMA, 
> > and I do know of several research projects in this space, but I don't 
> > know if/when any of these are planning on submission. If others are 
> > submitted, it would certainly be simple to add the hooks back in.
> 
> Too bad the main trusted knoppix site appears to be dead.  Was it
> actually making use of the templating api?
> 
> -serge

I believe they are using an older version of IMA without templating, 
but either way really shouldn't affect them.

dave
