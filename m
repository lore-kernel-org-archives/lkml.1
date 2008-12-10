Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYLJU3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYLJU3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYLJU3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:29:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbYLJU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:29:32 -0500
Date: Wed, 10 Dec 2008 12:29:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, netdev@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: sshd segmentation fault on ia64 on 28-rc7-mmotm-081203 -
 bisected
Message-Id: <20081210122928.2bf923ce.akpm@linux-foundation.org>
In-Reply-To: <1228940487.6139.68.camel@lts-notebook>
References: <1228322600.6693.61.camel@lts-notebook>
	<1228940487.6139.68.camel@lts-notebook>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 15:21:26 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Wed, 2008-12-03 at 11:43 -0500, Lee Schermerhorn wrote:
> > I couldn't find anything on the list about this.
> > 
> > I've built and booted 28-rc7-mmotm-081203 on both x86_64 and ia64.  I
> > can ssh into the x86_64 platform fine.  On the ia64, I'm seeing sshd
> > [from RHEL5 distro] seg faulting.  [Same sshd worked on the
> > 28-rc6-mmotm-081201 kernel.]
> > 
> > Has anyone else seen this?
> > 
> 
> I finally got around to bisecting this--sshd fails with SEGV on ia64--on
> mmotm-081208.  It appears to be caused by the patch duo:
> 
> do_mpage_readpage-remove-first_logical_block-parameter.patch
> do_mpage_readpage-remove-first_logical_block-parameter-fix.patch
> 

Thanks, I dropped them.
