Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbXEPG6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbXEPG6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXEPG62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:58:28 -0400
Received: from verein.lst.de ([213.95.11.210]:33106 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXEPG61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:58:27 -0400
Date: Wed, 16 May 2007 08:57:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC/PATCH 2/2] Make map_vm_area() static
Message-ID: <20070516065743.GB9884@lst.de>
References: <20070516034600.8A7C6DDEE7@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516034600.8A7C6DDEE7@ozlabs.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 01:45:29PM +1000, Benjamin Herrenschmidt wrote:
> map_vm_area() is only ever used inside of mm/vmalloc.c. This makes
> it static and removes the prototype.

Looks good.
