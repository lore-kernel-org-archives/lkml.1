Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYBJUQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYBJUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYBJUQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:16:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:45556 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYBJUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EWEj6u2qmFDgcKMUbQblNTfO7qvOTfGJCopQ2Q5BAd/Za8Cso3tEbqERgzoYUwVuHuTcbcoMlpAbsX5q/hi/l7pFKUNQQ9RvdD4NHvYe03bv8XJ0pdaGrVgxD4Nybnx104HbkuYJE9PSEtBGYIGS3nFQFZ2l/fbwPD7y8Qiuxfw=
Message-ID: <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
Date: Sun, 10 Feb 2008 12:16:43 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Cc: "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Tony Camuso" <tcamuso@redhat.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Loic Prylli" <loic@myri.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Martin Mares" <mj@ucw.cz>
In-Reply-To: <20080210145122.GC5299@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128204431.GA15227@kroah.com>
	 <20080128225334.GD4720@kroah.com>
	 <20080129025615.GC20198@parisc-linux.org>
	 <20080129030340.GE20198@parisc-linux.org>
	 <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>
	 <47AB299D.4000500@redhat.com>
	 <20080209124138.GA28967@parisc-linux.org>
	 <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
	 <20080210072116.GA12375@kroah.com>
	 <20080210145122.GC5299@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 6:51 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Feb 09, 2008 at 11:21:16PM -0800, Greg KH wrote:
> > Can I get a revised version of this, without the incorrect hunk?
>
> Sure.  I've even rebased it against current HEAD.  Damn whitespace
> cleanup introducing unnecessary conflicts ....
>
> I suggest Ivan's patch be merged ASAP as it actually fixes bugs.
> This patch is just cleanup (and takes care of some future concerns).

your patch and Ivan's patch should be merged in one...

YH
