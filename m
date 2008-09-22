Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYIVV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYIVV7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYIVV7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:59:07 -0400
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:36780 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754093AbYIVV7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:59:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=NFr8K7kxB69eNgUswZ69O5TzeEkVQloVM4p7iIMri9SC+FZbJ2Ry7RdDb374Jpbgndv/TWX4EaB557Oq18MvXSBMfmzkQ6CiLmEFpjdAKAs6it8KSahb5zx4FtLhyOMn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-09-22-01-36 uploaded (kvm)
Date: Mon, 22 Sep 2008 14:58:52 -0700
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, avi@qumranet.com, kvm@vger.kernel.org,
       "Williams, Dan J" <dan.j.williams@intel.com>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org> <20080922111947.507e34b1.randy.dunlap@oracle.com> <20080922125227.2b837457.akpm@linux-foundation.org>
In-Reply-To: <20080922125227.2b837457.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221458.53192.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 22, 2008 12:52 pm Andrew Morton wrote:
> On Mon, 22 Sep 2008 11:19:47 -0700
>
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> > >
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > >
> > > It contains the following patches against 2.6.27-rc7:
> >
> > ERROR: "intel_iommu_found" [arch/x86/kvm/kvm.ko] undefined!
> >
> > when CONFIG_DMAR=n.
>
> Yes, I got that too.  i386 allmodconfig fails similarly.  It's still
> unclear which tree in linux-next broke it.  PCI or async_tx, perhaps.

I don't have that symbol in my tree (yet).  It's part of one of the IOMMU KVM 
patch sets that's currently in-flight.  I'll add it to my linux-next tree 
today or tomorrow, assuming I get an ack from David about it (I'll bounce it 
over to him now).

Thanks,
Jesse
