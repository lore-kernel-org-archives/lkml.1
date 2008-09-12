Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYILUZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYILUZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYILUZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:25:01 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:34816 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYILUZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v6PakPX0PLOaZhQCvPu+EhlU0Q2r8ity6DPRZZh5o/ehrhNpeEzBQqlwG0eEC1J1gR
         LobsViOIPuOa3ylF1uWNFznd6ugUFZf71QbkCztEVFscUnJp3mE3n5Lz/3Cz2ntUegzS
         hqrGaC3MmzvfrsKgc8pGdXm7KCTzAYePEajIY=
Message-ID: <7af24c80809121324o26667cc8o3a7e2ba7414112ff@mail.gmail.com>
Date: Fri, 12 Sep 2008 22:24:57 +0200
From: "Kai Henningsen" <kai.extern@googlemail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Cc: "Joseph Fannin" <jfannin@gmail.com>, "Greg KH" <greg@kroah.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Thierry Vignaud" <tvignaud@mandriva.com>,
       "David Miller" <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <1221229964.3919.38.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080910.160505.14060698.davem@davemloft.net>
	 <1221151165.6309.55.camel@californication>
	 <20080911201541.GA18518@kroah.com>
	 <1221165518.4077.17.camel@macbook.infradead.org>
	 <20080911205738.GB11708@kroah.com>
	 <1221167725.4077.34.camel@macbook.infradead.org>
	 <20080911220700.GD5823@kroah.com>
	 <1221171943.4077.59.camel@macbook.infradead.org>
	 <20080912083927.GA13849@nineveh.local>
	 <1221229964.3919.38.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 16:32, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2008-09-12 at 04:39 -0400, Joseph Fannin wrote:
>> On Thu, Sep 11, 2008 at 03:25:43PM -0700, David Woodhouse wrote:
>> > On Thu, 2008-09-11 at 15:07 -0700, Greg KH wrote:
>> <snip>
>>
>> > Now, can we _please_ stop being bloody stupid? If there are _real_
>> > problems, like the one I fixed with commit 1cede1af last week, then I'm
>> > perfectly happy to deal with them. But stop making crap up.
>>
>> I CAN'T INSTALL MORE THAN ONE KERNEL PACKAGE > v2.6.26.
>>
>> IT'S NOT IMAGINARY.
>>
>> IT USED TO WORK AND YOU BROKE IT.
>
> Then your kernel packaging is broken. Fix it.

I might be confused here, but my impression is that he complains about
packaging that is part of the kernel sources. That really makes it a
stretch to call it "his" packaging.

Let's see ... yes, scripts/packaging stuff ... assuming I parsed
MAINTAINERS correctly, that means it belongs to

KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
P:      Sam Ravnborg
M:      sam@ravnborg.org
T:      git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
T:      git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
L:      linux-kbuild@vger.kernel.org
S:      Maintained

No?

I've never used that stuff myself. I prefer working with the (Debian)
kernel-package (make-kpkg) tool, which is also used to create the
distribution packages I believe, and which when I last used it
certainly had an active maintainer.
