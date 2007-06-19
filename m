Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXFSX5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXFSX5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbXFSX47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:56:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50149 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755495AbXFSX47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:56:59 -0400
Date: Tue, 19 Jun 2007 16:56:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
In-Reply-To: <20070619235046.GA2228@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0706191656260.16766@schroedinger.engr.sgi.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
 <20070619213808.716432000@askeshav-devel.jf.intel.com>
 <Pine.LNX.4.64.0706191627060.15951@schroedinger.engr.sgi.com>
 <20070619235046.GA2228@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Keshavamurthy, Anil S wrote:

> Memory allocated during driver init is very less and not much benefit
> with the suggested changes I think. Please correct me If I am wrong.

If its just a small amount of memory then the benefit will not be large. 
You are likely right.

> The biggest benifit will be when we can figure out GPF_XXXX flags
> during runtime when DMA map api's are called. 

Right.

