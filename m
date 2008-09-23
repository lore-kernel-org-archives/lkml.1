Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYIWGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYIWGdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYIWGdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:33:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbYIWGdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:33:41 -0400
From: Amit Shah <amit.shah@redhat.com>
Organization: Red Hat, Inc.
To: Andrew Morton <akpm@linux-foundation.org>, avi@qumranet.com
Subject: Re: mmotm 2008-09-22-01-36 uploaded (kvm)
Date: Tue, 23 Sep 2008 12:02:00 +0530
User-Agent: KMail/1.9.9
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org, kvm@vger.kernel.org,
       dan.j.williams@intel.com
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org> <200809221458.53192.jbarnes@virtuousgeek.org> <20080922151026.64715dc4.akpm@linux-foundation.org>
In-Reply-To: <20080922151026.64715dc4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231202.00856.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* On Tuesday 23 Sep 2008 03:40:26 Andrew Morton wrote:
> On Mon, 22 Sep 2008 14:58:52 -0700
>
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Monday, September 22, 2008 12:52 pm Andrew Morton wrote:
> > > On Mon, 22 Sep 2008 11:19:47 -0700
> > >
> > > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > > On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:
> > > > > The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> > > > >
> > > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > >
> > > > > It contains the following patches against 2.6.27-rc7:
> > > >
> > > > ERROR: "intel_iommu_found" [arch/x86/kvm/kvm.ko] undefined!
> > > >
> > > > when CONFIG_DMAR=n.
> > >
> > > Yes, I got that too.  i386 allmodconfig fails similarly.  It's still
> > > unclear which tree in linux-next broke it.  PCI or async_tx, perhaps.
> >
> > I don't have that symbol in my tree (yet).  It's part of one of the IOMMU
> > KVM patch sets that's currently in-flight.  I'll add it to my linux-next
> > tree today or tomorrow, assuming I get an ack from David about it (I'll
> > bounce it over to him now).
>
> It's already there, and exported in linux-next.  But it just doesn't get
> compiled in due to some Kconfig snafu.

This was introduced in the KVM tree.

Avi, please pick this up:

http://article.gmane.org/gmane.comp.emulators.kvm.devel/21770

or Mike Day's patches that fix the kernel as well as userspace build:

1/2: http://article.gmane.org/gmane.comp.emulators.kvm.devel/21813

2/2: http://article.gmane.org/gmane.comp.emulators.kvm.devel/21814
