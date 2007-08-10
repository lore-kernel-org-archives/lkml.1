Return-Path: <linux-kernel-owner+w=401wt.eu-S942067AbXHJVD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942067AbXHJVD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbXHJVC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:02:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52986 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754875AbXHJVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:02:57 -0400
Date: Fri, 10 Aug 2007 22:10:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       coreteam@netfilter.org
Subject: Re: [PATCH 1/7] sysctl: Remove broken cdrom binary sysctls
Message-ID: <20070810221018.622ae666@the-village.bc.nu>
In-Reply-To: <m1ps1vw1ey.fsf_-_@ebiederm.dsl.xmission.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com>
	<46BC944F.9020801@googlemail.com>
	<m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
	<20070810124156.2de9710e.akpm@linux-foundation.org>
	<m1ps1vw1ey.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 15:00:05 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> The binary interface for the cdrom sysctls can't possilby work.
> So remove the binary sysctls and reduce cdrom_sysctl_handler
> to it's essentials (to kill the uses of ctl_name).
> 
> Since the last time this patch was posted I radically
> simplified cdrom_sysctl_helper to meet address Alan's objections.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Alan Cox <alan@redhat.com>
