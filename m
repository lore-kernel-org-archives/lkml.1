Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYLJUVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYLJUVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYLJUVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:21:21 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:19536 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYLJUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:21:20 -0500
Subject: Re: sshd segmentation fault on ia64 on 28-rc7-mmotm-081203 -
	bisected
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, fbuihuu@gmail.com
Cc: netdev@vger.kernel.org, linux-ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <1228322600.6693.61.camel@lts-notebook>
References: <1228322600.6693.61.camel@lts-notebook>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 10 Dec 2008 15:21:26 -0500
Message-Id: <1228940487.6139.68.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 11:43 -0500, Lee Schermerhorn wrote:
> I couldn't find anything on the list about this.
> 
> I've built and booted 28-rc7-mmotm-081203 on both x86_64 and ia64.  I
> can ssh into the x86_64 platform fine.  On the ia64, I'm seeing sshd
> [from RHEL5 distro] seg faulting.  [Same sshd worked on the
> 28-rc6-mmotm-081201 kernel.]
> 
> Has anyone else seen this?
> 

I finally got around to bisecting this--sshd fails with SEGV on ia64--on
mmotm-081208.  It appears to be caused by the patch duo:

do_mpage_readpage-remove-first_logical_block-parameter.patch
do_mpage_readpage-remove-first_logical_block-parameter-fix.patch

Lee

