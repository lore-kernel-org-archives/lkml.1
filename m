Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbZEKV2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbZEKV2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbZEKV2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:28:23 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:33131 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759872AbZEKV2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:28:23 -0400
Date: Mon, 11 May 2009 21:27:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
In-Reply-To: <4A052721.4010201@kernel.org>
Message-ID: <alpine.DEB.1.10.0905112126410.28512@qirst.com>
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Yinghai Lu wrote:

> when node only have hot add range and don't have other static range.
> that node will not be onlined, and cpus on that will be linked to nearby
> node with memory.
> then when that host add range is added later, we need to linked those cpus
> back.

This going to be fun for the allocators that have put their queues on the
respective nodes. How are the various OS structures that were allocated on
the node that is downed / upped relocated?

