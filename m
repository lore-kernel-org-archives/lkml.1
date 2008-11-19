Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYKSXiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYKSXiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYKSXim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:38:42 -0500
Received: from ozlabs.org ([203.10.76.45]:32920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYKSXil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:38:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH 1/1] cpumask: smp_call_function_many()
Date: Thu, 20 Nov 2008 10:08:31 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, npiggin@suse.de,
       axboe@kernel.dk
References: <20081119144710.59CA1DDDDB@ozlabs.org> <492475BF.6090502@ct.jp.nec.com>
In-Reply-To: <492475BF.6090502@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201008.31978.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008 06:53:27 Hiroshi Shimamoto wrote:
> Rusty Russell wrote:
> > +	/* Fastpath: do that cpu by itself. */
> > +	if (next_cpu >= nr_cpu_ids)
> > +		smp_call_function_single(cpu, func, info, wait);
>
> Hi Rusty,
>
> I think, return is needed here. If not func will be called twice.

Indeed, thanks!

Fixed,
Rusty.

