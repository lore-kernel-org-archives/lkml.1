Return-Path: <linux-kernel-owner+w=401wt.eu-S965696AbXCMMHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696AbXCMMHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965702AbXCMMHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:07:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54165 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965696AbXCMMHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:07:12 -0400
Date: Tue, 13 Mar 2007 13:07:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
Message-ID: <20070313130755.21d32627@lxorguk.ukuu.org.uk>
In-Reply-To: <20070313080150.7C9061801C5@magilla.sf.frob.com>
References: <Pine.LNX.4.44L0.0703091253050.2611-100000@iolanthe.rowland.org>
	<20070313080150.7C9061801C5@magilla.sf.frob.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 01:00:50 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> > Well, I can add in the test for 0, but finding the set of always-on bits
> > in DR6 will have to be done separately.  Isn't it possible that different
> > CPUs could have different bits?
> 
> I don't know, but it seems unlikely.  AFAIK all CPUs are presumed to have
> the same CPUID results, for example.

No. We merge the CPUID information to get a shared set of capability bits.

Generic PC systems with a mix of PII and PIII are possible. The voyager
architecture can have even more peculiar combinations of processor
modules installed.

