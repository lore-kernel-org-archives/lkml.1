Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYFKBnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYFKBnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 21:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYFKBnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 21:43:35 -0400
Received: from smtp.mail.umich.edu ([141.211.93.160]:40914 "EHLO
	skycaptain.mr.itd.umich.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbYFKBnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 21:43:35 -0400
From: Matt Reuther <mreuther@umich.edu>
Organization: The Knights Who Say... Ni!
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1: modules_install error: 9p.ko ignored, due to loop
Date: Tue, 10 Jun 2008 21:43:23 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
References: <200806081234.53080.mreuther@umich.edu> <20080609142127.ea4c8aab.akpm@linux-foundation.org>
In-Reply-To: <20080609142127.ea4c8aab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806102143.24549.mreuther@umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008 05:21:27 pm Andrew Morton wrote:
> On Sun, 8 Jun 2008 12:34:52 -0400
>
> Matt Reuther <mreuther@umich.edu> wrote:
> > I compiled and then tried to install the 2.6.26-rc2-mm1, and I got this
> > message. I didn't see this discussed anywhere.
> >
> > WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/fs/9p/9p.ko ignored,
> > due to loop
> > WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet_fd.ko
> > ignored, due to loop
> > WARNING: Loop detected:
> > /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet.ko needs 9pnet_fd.ko
> > which needs 9pnet.ko again!
> > WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet.ko
> > ignored, due to loop
> > WARNING: Module /lib/modules/2.6.26-rc2-mm1/kernel/net/9p/9pnet_virtio.ko
> > ignored, due to loop
> >
> > My .config is attached.
>
> Thanks.  I was unable to reproduce this with your config in
> 2.6.26-rc5-mm1.  Perhaps sometime you could check that it is fixed for
> you also?

I ran the same config on 2.6.26-rc5-mm2, and there is no problem with the 
install on that one.

Thanks for your help!
Matt
