Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbXJaOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbXJaOyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXJaOyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 10:54:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:48097 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbXJaOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 10:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TQv7SjgOcNh5aCaK6PibR2zfqnm0Y4SI2KghcRohwWkSsCpqiROa2kl2UTKAKmTizP5SilZIxkmv+8PxyoJEBLTeQkC4/rctR+Tzgz+jDp1hn3PxaTiXOn2kVVIDe592QClvnkIoLwN977NEmNjnMNhP2BtY/3e6unmaABBde0g=
Message-ID: <170fa0d20710310754h55d768bdgb67f30b54174e680@mail.gmail.com>
Date: Wed, 31 Oct 2007 10:54:02 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/33] Swap over NFS -v14
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "David Miller" <davem@davemloft.net>, nickpiggin@yahoo.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
In-Reply-To: <1193828206.27652.145.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071030160401.296770000@chello.nl>
	 <200710311426.33223.nickpiggin@yahoo.com.au>
	 <20071030.213753.126064697.davem@davemloft.net>
	 <20071031085041.GA4362@infradead.org>
	 <1193828206.27652.145.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2007-10-31 at 08:50 +0000, Christoph Hellwig wrote:
> > On Tue, Oct 30, 2007 at 09:37:53PM -0700, David Miller wrote:
> > > Don't be misled.  Swapping over NFS is just a scarecrow for the
> > > seemingly real impetus behind these changes which is network storage
> > > stuff like iSCSI.
> >
> > So can we please do swap over network storage only first?  All these
> > VM bits look conceptually sane to me, while the changes to the swap
> > code to support nfs are real crackpipe material.
>
> Yeah, I know how you stand on that. I just wanted to post all this
> before going off into the woods reworking it all.
...
> > So please get the VM bits for swap over network blockdevices in first,
>
> Trouble with that part is that we don't have any sane network block
> devices atm, NBD is utter crap, and iSCSI is too complex to be called
> sane.
>
> Maybe Evgeniy's Distributed storage thingy would work, will have a look
> at that.

Andrew recently asked Evgeniy if his DST was ready for merging; to
which Evgeniy basically said yes:
http://lkml.org/lkml/2007/10/27/54

It would be great if DST could be merged; whereby addressing the fact
that NBD is lacking for net-vm.  If DST were scrutinized in the
context of net-vm it should help it get the review that is needed for
merging.

Mike
