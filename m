Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYBJGZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYBJGZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYBJGZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:25:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:35428 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYBJGZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZbNpotuuJDBgXyL972WWtM5xuLUR1n7I01XQUCAet4cD/rzX1v80UabLS351lZkEneES8ksb5DxZcQk5ZWdg7C6OkEqGmrXih/qABPJNel2XivfCw74VF6DNjnckbtI1LnThWXRXH/pO5tFul66KtcBwEwBxGwgwMvMvHRa97zk=
Message-ID: <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
Date: Sat, 9 Feb 2008 22:25:23 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Cc: "Tony Camuso" <tcamuso@redhat.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Loic Prylli" <loic@myri.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Martin Mares" <mj@ucw.cz>
In-Reply-To: <20080209124138.GA28967@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115175641.GE18741@parisc-linux.org>
	 <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com>
	 <20080128223141.GA31101@parisc-linux.org>
	 <20080128225334.GD4720@kroah.com>
	 <20080129025615.GC20198@parisc-linux.org>
	 <20080129030340.GE20198@parisc-linux.org>
	 <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>
	 <47AB299D.4000500@redhat.com>
	 <20080209124138.GA28967@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2008 4:41 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, Feb 07, 2008 at 10:54:05AM -0500, Tony Camuso wrote:
> > Matthew,
> >
> > Perhaps I missed it, but did you address Yinghai's concerns?
>
> No, I was on holiday.
>
> > Yinghai Lu wrote:
> > >On Jan 28, 2008 7:03 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > >>
> > >>-int pci_conf1_write(unsigned int seg, unsigned int bus,
> > >>+static int pci_conf1_write(unsigned int seg, unsigned int bus,
> > >>                           unsigned int devfn, int reg, int len, u32
> > >>                           value)
> > >
> > >any reason to change pci_conf1_read/write to static?
>
> Yes -- it no longer needs to be called from outside this file.
>
> > >>+config ATA_RAM
> > >>+       tristate "ATA RAM driver"
> > >>+
> > >
> > >related?
>

looks good. it should get into -mm or x86/mm for some testing

YH
