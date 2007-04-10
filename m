Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXDJFHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXDJFHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 01:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966056AbXDJFHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 01:07:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:31099 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbXDJFHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 01:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eyrhn1wfvKO19xlcqK4vzEBxGSRbBDMrNLkzXS1sCAzzd3oF6g9e/zTHXovbO2yFDqpHlfYPYw3bBc4Vihr1+GkDB/VxihKmMib4FXfFdpnoxXBWxckBtEnUQy7xn/N6Q9NVDUOHSKqTPMUKXov8q5OFxqwS1lW8j39+6ohVA80=
Date: Tue, 10 Apr 2007 09:07:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410050754.GB5836@martell.zuzino.mipt.ru>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409193056.6b52c354.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 07:30:56PM -0700, Andrew Morton wrote:
> On Mon, 9 Apr 2007 21:59:12 -0400 Dave Jones <davej@redhat.com> wrote:

[possible topic for KS2007]

> >   164 ?        S<     0:00 [cqueue/0]
> >   165 ?        S<     0:00 [cqueue/1]
> >
> > I'm not even sure wth these are.
>
> Me either.

drivers/connector/connector.c:
455	dev->cbdev = cn_queue_alloc_dev("cqueue", dev->nls);

