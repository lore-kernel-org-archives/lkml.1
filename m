Return-Path: <linux-kernel-owner+w=401wt.eu-S1762587AbXEPDtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762587AbXEPDtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbXEPDtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:49:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:35180 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbXEPDtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:49:33 -0400
Subject: Re: [RFC/PATCH 1/2] powerpc: unmap_vm_area becomes
	unmap_kernel_range
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linux Memory Management <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20070516034600.18427DDEE4@ozlabs.org>
References: <20070516034600.18427DDEE4@ozlabs.org>
Content-Type: text/plain
Date: Wed, 16 May 2007 13:48:37 +1000
Message-Id: <1179287317.32247.207.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 13:45 +1000, Benjamin Herrenschmidt wrote:
> This patch renames unmap_vm_area to unmap_kernel_range and make
> it take an explicit range instead of a vm_area struct. This makes
> it more versatile for code that wants to play with kernel page
> tables outside of the standard vmalloc area.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org> 

BTW, sorry for the incorrect title, it's not powerpc specific really
(though I want to use the new function from powerpc code)

Ben.


