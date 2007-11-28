Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXK1UDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXK1UDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXK1UDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:03:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385AbXK1UDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:03:11 -0500
Date: Wed, 28 Nov 2007 12:03:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2 (build failure on s390)
Message-Id: <20071128120308.403106ac.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711281151130.12651@schroedinger.engr.sgi.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711281151130.12651@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 11:52:19 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> Cross build with s390 default configuration (make defconfig) fails
> 
>   CC      arch/s390/kernel/irq.o
>   CC      arch/s390/kernel/ipl.o
>   CC      arch/s390/kernel/dis.o
>   CC      fs/open.o
>   LD      arch/s390/hypfs/s390_hypfs.o
> arch/s390/kernel/ipl.c: In function 'ipl_register_fcp_files':
> arch/s390/kernel/ipl.c:415: error: 'ipl_subsys' undeclared (first use in 
> this function)
> arch/s390/kernel/ipl.c:415: error: (Each undeclared identifier is reported 
> only once
> arch/s390/kernel/ipl.c:415: error: for each function it appears in.)
> arch/s390/kernel/ipl.c: In function 'ipl_init':
> arch/s390/kernel/ipl.c:449: error: implicit declaration of function 
> 'firmware_register'
> arch/s390/kernel/ipl.c:449: error: 'ipl_subsys' undeclared (first use in 
> this func

yes, that's the file which got a reject storm which I didn't have the
energy to fix.
