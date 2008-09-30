Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYI3PfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYI3PfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYI3PfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:35:16 -0400
Received: from waste.org ([66.93.16.53]:48630 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYI3PfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:35:15 -0400
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
From: Matt Mackall <mpm@selenic.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       penberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1222787736.2995.24.camel@castor.localdomain>
References: <1222787736.2995.24.camel@castor.localdomain>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 10:32:48 -0500
Message-Id: <1222788768.23159.26.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-30 at 16:15 +0100, Richard Kennedy wrote:
> reduce the total stack usage of slab_err & object_err.

I've got a better idea: use vprintk.

-- 
Mathematics is the supreme nostalgia of our time.

