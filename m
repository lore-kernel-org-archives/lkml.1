Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYDCQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYDCQg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYDCQgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:36:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbYDCQgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:36:20 -0400
Date: Thu, 3 Apr 2008 09:30:42 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: schwidefsky@de.ibm.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, jens.axboe@oracle.com, m-ikeda@ds.jp.nec.com,
       zaitcev@redhat.com
Subject: Re: kernel BUG at drivers/block/ub.c:820!
Message-Id: <20080403093042.f20e38a2.zaitcev@redhat.com>
In-Reply-To: <1207235911.9155.16.camel@localhost>
References: <1207212156.5602.5.camel@localhost>
	<20080403.110825.07645490.k-ueda@ct.jp.nec.com>
	<1207235911.9155.16.camel@localhost>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2008 17:18:31 +0200, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> On Thu, 2008-04-03 at 11:08 -0500, Kiyoshi Ueda wrote:

> > I believe the patch from Pete fixes this BUG():
> >     http://marc.info/?l=linux-usb&m=120613888005382&w=2
> > 
> > Could you try that?
> 
> Just tested the patch and it indeed fixes the bug.

I'm glad.

> Could we push this upstream for 2.6.25? It is a regression, I would
> prefer to have a 2.6.25 that doesn't panic my machine when I attach a
> USB stick..

I was going to work through Greg as usual and then push it to
the stable tree. I'm not Linus' "leutenant", so I cannot just send
him random patches.

-- Pete
