Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZCDXc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZCDXc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZCDXcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:32:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42784 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZCDXcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pRD94DvsKc6zu40jHXnhUMEPTfDcpDXyDYNQT6O3JW0T1nhrpaDy7H40ix/fRcJdwH
         /+MErdoJ6eQ/W+U6k0lKpf0CbGnGBy/gVGZSzCvYjeX5qdUNuhiu+g2Qn6BttM+8r99d
         3nUA27bP199OBnLm+Vav/suzw73UJkbJLhEU4=
Date: Thu, 5 Mar 2009 01:32:24 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12574] possible circular locking dependency detected
Message-ID: <20090304233224.GA7023@google.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <SLCXkuHtxAO.A.LtE.VWarJB@chimera> <8f53421d0903031419m493b88bbifa911323279f4f0b@mail.gmail.com> <200903032342.36851.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903032342.36851.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 11:42:36PM +0100, Rafael J. Wysocki wrote:
> On Tuesday 03 March 2009, Michael S. Tsirkin wrote:
> > On Tue, Mar 3, 2009 at 9:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12574
> > > Subject         : possible circular locking dependency detected
> > > Submitter       : Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> > > Date            : 2009-01-29 11:35 (34 days old)
> > > References      : http://lkml.org/lkml/2009/2/9/205
> > >
> > >
> > >
> > 
> > I don't seem to observe this warning in v2.6.29-rc6 anymore.
> 
> OK, I'm going to close it, then.

Spoke too soon.
I see this again on 2.6.29-rc7.


