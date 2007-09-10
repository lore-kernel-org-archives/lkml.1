Return-Path: <linux-kernel-owner+w=401wt.eu-S965865AbXIJTiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbXIJTiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932710AbXIJTiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:38:10 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:36651 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbXIJTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FHCk8Ox4sZr49nH4HGsI+870xqMVy1XeBd8q7aYJOvr2vpXz5hcnl+riFqKTpjZiMS2u1ljeJNdytfd3FuubjaDhNFvKCOOJiDN+hBDqPvCBAs9rdesG92b0JhlUNdv9cndN+RsoIIi0a+RWjTciG7O4dMMrvCLuPGfjQsOAORo=
Message-ID: <64bb37e0709101238s18c929b2l131d96fc40af208c@mail.gmail.com>
Date: Mon, 10 Sep 2007 21:38:04 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1
Cc: "Andy Whitcroft" <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie, "Jens Axboe" <jens.axboe@oracle.com>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20070910122038.1f1bb006.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	 <20070910174926.GC30335@shadowen.org>
	 <20070910111926.9c942358.akpm@linux-foundation.org>
	 <64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com>
	 <20070910122038.1f1bb006.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 10 Sep 2007 20:59:49 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > On 9/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Mon, 10 Sep 2007 18:49:26 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> > I reported a similar problem on Sep 1, but until now got no response.
>
> You still haven't had a response ;)  Let's add a cc.

But the mail from Andy was a nice point to try to another cc, i.e.
linux-scsi that you added. :)

> Oh, you reported it against 2.6.23-rc4-mm1
> (http://lkml.org/lkml/2007/9/1/92) and I did cc linux-ide in my response.
>
[snip]
> Andy is using qla1280.  You're using sata.  So it's probably a different
> bug, with the same symptoms.

Yes, but you (Andrew) also said in response to Andy: "If it's not that then
perhaps something in scsi core broke, dunno." So I wanted to add that
my problem migth point this bug into the core direction.

> Can you please confirm that this bug is present in -mm and not present in
> mainline (yet)?

Currently using 2.6.23-rc3-mm1, that works for me.
Now downloading 2.6.23-rc5-git1...

Torsten
