Return-Path: <linux-kernel-owner+w=401wt.eu-S967287AbXEHSWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967287AbXEHSWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966725AbXEHSWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:22:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46579 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966264AbXEHSWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:22:07 -0400
Date: Tue, 8 May 2007 11:22:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srinivasa Ds <srinivasa@in.ibm.com>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel expection generated with 2.6.21-mm1 kernel boot up
In-Reply-To: <46406816.8030106@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0705081119590.10126@schroedinger.engr.sgi.com>
References: <463F196C.9070501@linux.vnet.ibm.com> <46406816.8030106@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Srinivasa Ds wrote:

> Looks like there is a bug in SLUB implementaion for ppc64 in 2.6.21-mm1.
> I unmarked CONFIG_SLUB and build the kernel, its booting cleary now.
> 
> Thanks
>  Srinivasa DS

This is a known issue for PPC with more than 4 processors. Work is in 
progress for a general fix.

You should have not been able to select SLUB at all given that you have 4 
processor configured. Hmmm... The Kconfig comparison for more than 4 cpus 
does only seem to work in certain cases.

Could I have a complete .config?
