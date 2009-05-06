Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZEFGmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZEFGmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZEFGmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:42:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbZEFGmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:42:38 -0400
Date: Tue, 5 May 2009 23:20:58 -0700
From: Greg KH <gregkh@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, mel@csn.ul.ie,
       stable@kernel.org
Subject: Re: patch
	mm-fix-committed_as-underflow-on-large-nr_cpus-environment.patch
	added to 2.6.29-stable tree
Message-ID: <20090506062058.GA6916@suse.de>
References: <20090504220454.3F71148FB8@coco.kroah.org> <200905052036.24106.s.L-H@gmx.de> <20090505221403.GA4714@suse.de> <2f11576a0905051526j73dd1570nb440e4b78e3b35a9@mail.gmail.com> <20090505225932.GA4982@suse.de> <2f11576a0905051612p140e077fva214e954273a39df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0905051612p140e077fva214e954273a39df@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 08:12:21AM +0900, KOSAKI Motohiro wrote:
> > On Wed, May 06, 2009 at 07:26:51AM +0900, KOSAKI Motohiro wrote:
> >> Could you please post oops log?
> >> current mmotm (include this patch) works fine on my x86_64 box. Then,
> >> I have no hint now ;-)
> >
> > Attached is a picture of the oops.
> >
> > Hope this helps,
> 
> OK, the reason is 99% mis-applied patch. I've made rebased patch.
> 
> in my environment
> 
> 2.6.29.2 + original patch:  panic
> 2.6.29.2 + rebased patch:  works well
> 
> Could you please try it?

thank you for looking into this, I'll try it out tomorrow morning and
let you know how it goes.

greg k-h
