Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXCWBlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXCWBlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934267AbXCWBlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:41:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbXCWBlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:41:45 -0400
Date: Thu, 22 Mar 2007 17:41:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?B?TWFnYWxs824i?= <jamagallon@ono.com>"@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070322174140.095753a1.akpm@linux-foundation.org>
In-Reply-To: <20070323002709.3d45aa19@werewolf-wl>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070323002709.3d45aa19@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please always do reply-to-all.

On Fri, 23 Mar 2007 00:27:09 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Mon, 19 Mar 2007 20:56:23 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> > 
> 
> Is anybody having problems with optical drives and this kernel ?
> I can't get my dvdrw to spit any events to udevmonitor. If I mount it
> manually everything works fine.

Yes, I think one person reported something similar.

> Perhaps the problem is in hal/g-v-m or anything else, but I suppose that
> udevmonitor receives events directly from kernel, isn't it ?

Probably related to the not-yet-completely-solved firmware loader failures.

It would be good if someone could do a bisection search on this.  I face a
fun evening hunting down a horrendous ext3 performance regression which is
now in mainline.

