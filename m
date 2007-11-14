Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbXKNN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbXKNN6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXKNN6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:58:11 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:61777 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbXKNN6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:58:10 -0500
Date: Wed, 14 Nov 2007 05:51:04 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>, hch@infradead.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       wcohen@redhat.com, robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114135104.GE6557@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071114103805.GA16652@infradead.org> <18234.53558.883970.87414@cargo.ozlabs.ibm.com> <20071114110009.GA17833@infradead.org> <20071114.031216.11725447.davem@davemloft.net> <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Nov 14, 2007 at 10:44:56PM +1100, Paul Mackerras wrote:
> David Miller writes:
> 
> > This is my impression too, all of the things being done with
> > a slew of system calls would be better served by real special
> > files and appropriate fops.
> 
> Special files and fops really only work well if you can coerce the
> interface into one where data flows predominantly one way.  I don't
> think they work so well for something that is more like an RPC across
> the user/kernel barrier.  For that a system call is better.
> 
> For instance, if you have something that kind-of looks like
> 
> 	read_pmds(int n, int *pmd_numbers, u64 *pmd_values);
> 
> where the caller supplies an array of PMD numbers and the function
> returns their values (and you want that reading to be done atomically
> in some sense), how would you do that using special files and fops?
> 
Yes, the read call could be simplified to the level proposed above by Paul.

-- 
-Stephane
