Return-Path: <linux-kernel-owner+w=401wt.eu-S1761872AbXFTEmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761872AbXFTEmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbXFTEl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:41:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:41975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbXFTElz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:41:55 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Date: Wed, 20 Jun 2007 00:41:42 -0400
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       linux-acpi@vger.kernel.org
References: <20070619225035.GI5193@alberich.amd.com> <20070619204934.f56722a8.randy.dunlap@oracle.com> <20070619205158.8d6da762.randy.dunlap@oracle.com>
In-Reply-To: <20070619205158.8d6da762.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706200041.42596.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 23:51, Randy Dunlap wrote:
> On Tue, 19 Jun 2007 20:49:34 -0700 Randy Dunlap wrote:
> 
> > On Tue, 19 Jun 2007 23:38:02 -0400 Len Brown wrote:
> > 
> > > On Tuesday 19 June 2007 18:50, Andreas Herrmann wrote:
> > > > Avoid compile warning if !ACPI_BLACKLIST_YEAR
> > > > 
> > > >   CC      drivers/acpi/blacklist.o
> > > >   drivers/acpi/blacklist.c:76:5: warning: "CONFIG_ACPI_BLACKLIST_YEAR" is not defined
> > > 
> > > How were you able to produce a .config with CONFIG_ACPI_BLACKLIST_YEAR not defined?
> > > Can you send it to me?
> > 
> > 'make randconfig' does that kind of thing.  It doesn't enforce/follow
> > "select" clauses.
> 
> I should have also said:  randconfig is good for detecting some
> missing conditions/configs or missing header files, but if you find one
> that is just plain Invalid (like some of these), just say so
> and do whatever you want with the patch (IMHO of course).

If randconfig ends up with impossible-for-a-user-to-generate configs,
then it seems seriously broken.  Perhaps it would make sense to run
"make oldconfig" after "make randconfig" -- or better yet, have that
built in?

-Len
