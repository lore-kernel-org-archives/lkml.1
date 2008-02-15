Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYBOQm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYBOQm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYBOQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:42:14 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53329 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753402AbYBOQmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:42:14 -0500
Date: Fri, 15 Feb 2008 08:42:13 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer in kmem_cache_alloc with 2.6.25-rc1
In-Reply-To: <1203058021.3027.143.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0802150839180.12023@schroedinger.engr.sgi.com>
References: <1203058021.3027.143.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Zhang, Yanmin wrote:

> On my 16-core tigerton, kernel panic when I ran hackbench process testing. See
> below log.
> 

> Kernel panic at line 1637 in file mm/slub.c because object=c->freelist=NULL.

Hmmmm. freelist should never be NULL. Could you rerun the test and boot with 
slub_debug to make sure that there is no memory corruption?
