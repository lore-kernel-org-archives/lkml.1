Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZEERDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZEERDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbZEERDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:03:10 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37900 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZEERDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:03:09 -0400
Subject: Re: [RFC PATCH 1/3] add generic hypercall support
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
In-Reply-To: <20090505132437.19891.42922.stgit@dev.haskins.net>
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
	 <20090505132437.19891.42922.stgit@dev.haskins.net>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 05 May 2009 12:03:07 -0500
Message-Id: <1241542987.24786.76.camel@slate.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 09:24 -0400, Gregory Haskins wrote:
> 
> *) PIO is more direct than MMIO, but it poses other problems such as:
>       a) can have a small limited address space (x86 is 2^16)
>       b) is a narrow-band interface (one 8, 16, 32, 64 bit word at a time)
>       c) not available on all archs (PCI mentions ppc as problematic) and
>          is therefore recommended to avoid.

Side note: I don't know what PCI has to do with this, and "problematic"
isn't the word I would use. ;) As far as I know, x86 is the only
still-alive architecture that implements instructions for a separate IO
space (not even ia64 does).

-- 
Hollis Blanchard
IBM Linux Technology Center

