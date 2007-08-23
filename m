Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbXHWJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbXHWJwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbXHWJwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:52:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43043 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbXHWJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:52:09 -0400
Subject: Re: [patch 0/6] Per cpu structures for SLUB
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070823064653.081843729@sgi.com>
References: <20070823064653.081843729@sgi.com>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 11:52:04 +0200
Message-Id: <1187862724.6114.356.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while I like this patch set I'm at odds with the interaction of this and
making the alloc/free fast paths lockless. 

The main race is s->cpu_slab[] and c->freelist. How does one close that
gap?

(btw, have you looked at my -rt slub patch?)

