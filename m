Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZEKOb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZEKOb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZEKObf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:31:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:54919 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZEKObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:31:34 -0400
Date: Mon, 11 May 2009 07:30:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511073053.4628b28c@infradead.org>
In-Reply-To: <ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
	<ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 16:14:28 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Mon, May 11, 2009 at 15:10, Alan Cox <alan@lxorguk.ukuu.org.uk>
> wrote:
> >> And I did, and it's obvious that creating a single file along with
> >> the ~10 we already create in /sys, instead of running through /sys
> >> or /proc later and reconstruct what we missed, is always, and in
> >> every case faster and simpler. It gets rid of a bunch of things we
> >> need to
> >
> > Arjan's numbers for sysfs are 0.06 seconds if I remember the mail
> > correctly. That doesn't account for any meaningful speedup.
> 
> Sure it does. It is great, and it started a huge effort for many
> people to think about the current way to do it. It is very welcome and
> it counts a lot, and there is no doubt, that most of the gains we get
> today are due to Arjans work in that area.
> 
> But he does not use an initramfs, and distros insist to do that. And
> that basically means you need to prepare /dev two times, and also prep

eh why?

this is the part I'm missing.
Make /dev in the initramfs, then bind-mount-move it to its final
location later. 

you ever only need to fill your tmpfs /dev once. initramfs or not.
