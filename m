Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbXCEBRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbXCEBRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXCEBRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:17:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbXCEBRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:17:47 -0500
Date: Sun, 4 Mar 2007 17:17:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?B?TWFnYWxs824i?= <jamagallon@ono.com>"@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070304171737.42c14570.akpm@linux-foundation.org>
In-Reply-To: <20070305011133.570a9ba8@werewolf-wl>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070305011133.570a9ba8@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 01:11:33 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> > 
> 
> nfs blocks shutdown and reboot.
> If I try to do 'service nfs stop', the box hangs, no login, no SysRQ-T or P,
> S-U-B works at least.
> 

The bug was added by
knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch.
