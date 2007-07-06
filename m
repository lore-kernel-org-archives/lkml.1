Return-Path: <linux-kernel-owner+w=401wt.eu-S1763914AbXGFRFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763914AbXGFRFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbXGFRFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:05:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44967 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbXGFRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:05:15 -0400
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
From: Peter Zijlstra <peterz@infradead.org>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <878x9ta320.fsf@wanadoo.fr>
References: <878x9ta320.fsf@wanadoo.fr>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 19:04:39 +0200
Message-Id: <1183741479.7054.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 18:51 +0200, Yoann Padioleau wrote:
> Transform some calls to kmalloc/memset to a single kzalloc (or
> kcalloc).
> 

Christoph, what is the plan wrt GFP_ZERO?

