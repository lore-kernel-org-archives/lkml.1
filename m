Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbZDGVzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbZDGVzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761062AbZDGVyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:54:54 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:51626 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbZDGVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:54:54 -0400
Date: Tue, 7 Apr 2009 17:48:43 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <alpine.DEB.2.00.0904071445200.27115@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0904071747400.12192@qirst.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi>
 <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com> <49DBB929.4080205@cs.helsinki.fi> <alpine.DEB.1.10.0904071641390.12192@qirst.com>
 <49DBBC1F.6000407@cs.helsinki.fi> <alpine.DEB.1.10.0904071728240.12192@qirst.com> <alpine.DEB.2.00.0904071445200.27115@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, David Rientjes wrote:

> Right, but right now allocating new slabs is extremely slow compared to
> using a partial slab.

Work on the page allocator is in progress. So this is band aid until the
work on the page allocator is complete. Maybe better focus on helping Mel?

