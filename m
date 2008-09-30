Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYI3Pwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYI3Pwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbYI3PwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:52:24 -0400
Received: from waste.org ([66.93.16.53]:45504 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbYI3PwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:52:23 -0400
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       penberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48E2480A.9090003@linux-foundation.org>
References: <1222787736.2995.24.camel@castor.localdomain>
	 <48E2480A.9090003@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 10:49:45 -0500
Message-Id: <1222789785.23159.27.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-30 at 10:38 -0500, Christoph Lameter wrote:
> Richard Kennedy wrote:
> > reduce the total stack usage of slab_err & object_err.
> > 
> > Introduce a new function to display a simple slab bug message, and call
> > this when vprintk is not needed.
> 
> You could simply get rid of the 100 byte buffer by using vprintk? Same method
> could be used elsewhere in the kernel and does not require additional
> functions. Compiles, untestted.

I'm fixing a bunch of these in the kernel right now.

-- 
Mathematics is the supreme nostalgia of our time.

