Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbYARU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbYARU6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761470AbYARU6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:58:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761173AbYARU6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:58:24 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
Date: Fri, 18 Jan 2008 21:58:18 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Oeser <ioe-lkml@rameria.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080118183011.354965000@sgi.com> <20080118204845.GD3079@elte.hu> <4791122E.8070205@sgi.com>
In-Reply-To: <4791122E.8070205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801182158.18822.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> How big is the stack during early startup?

THREAD_ORDER (runs on init_stack's stack)

early init stack could be increased in theory with some effort,
but since that is all single threaded anyways just a few strategic
static __initdata's should be simple enough.

-Andi
