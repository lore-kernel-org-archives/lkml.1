Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbXFLWoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbXFLWoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXFLWoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:44:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbXFLWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:44:09 -0400
Date: Tue, 12 Jun 2007 15:43:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>, avi@qumranet.com,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
Message-Id: <20070612154345.84b954d9.akpm@linux-foundation.org>
In-Reply-To: <20070612221629.GA24252@redhat.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070612000718.GS3588@stusta.de>
	<20070612032224.GA19293@redhat.com>
	<20070612150357.1685c622.akpm@linux-foundation.org>
	<20070612221629.GA24252@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007 18:16:29 -0400
Dave Jones <davej@redhat.com> wrote:

>  > >  # Read KERNELRELEASE from include/config/kernel.release (if it exists)
>  > 
>  > This causes the i386 allmodconfig build to fail:
> 
> Seems to be doing its job rather effectively.

err, hang on.  I had a different patch in there which hilariously broke
the build all over the place, and dropping that has made your patch
come good.  I'll put it back.
