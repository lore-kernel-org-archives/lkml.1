Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZBRKwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZBRKwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZBRKwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:52:13 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:44826 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZBRKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:52:12 -0500
Message-ID: <499BE7F8.80901@csr.com>
Date: Wed, 18 Feb 2009 10:50:32 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/7] slab: introduce kzfree()
References: <20090217182615.897042724@cmpxchg.org> <20090217184135.747921027@cmpxchg.org>
In-Reply-To: <20090217184135.747921027@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2009 10:50:32.0860 (UTC) FILETIME=[B8E105C0:01C991B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> +void kzfree(const void *p)

Shouldn't this be void * since it writes to the memory?

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
