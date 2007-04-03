Return-Path: <linux-kernel-owner+w=401wt.eu-S1945933AbXDCUkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945933AbXDCUkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945934AbXDCUkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:40:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50702 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945933AbXDCUkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:40:41 -0400
Date: Tue, 3 Apr 2007 13:40:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Badari Pulavarty wrote:

> On Mon, 2007-04-02 at 22:47 -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > 
> 
> SLUB code hangs my ppc64 machine on boot.

Could you enable NMI or something and get me a stackdump? PPC is notorious 
for having strange NUMA issues. Any fallbacks from node 0 on bootstrap? Is 
there memory on node 0?

