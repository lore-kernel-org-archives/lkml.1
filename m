Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0BETUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:20:05 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:43337 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0BETUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:20:01 -0500
Date: Fri, 5 Feb 2010 13:19:48 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: Re: [PATCH] [0/4] SLAB: Fix a couple of slab memory hotadd issues
In-Reply-To: <201002031039.710275915@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002051316350.25989@router.home>
References: <201002031039.710275915@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Andi Kleen wrote:

> This fixes various problems in slab found during memory hotadd testing.

It changes the bootstrap semantics. The requirement was so far that slab
initialization must be complete before slab operations can be used.

This patchset allows such use before bootstrap on a node is complete and
also allows the running of cache reaper before bootstrap is done.

I have a bad feeling that this could be the result of Pekka's changes to
the bootstrap.


