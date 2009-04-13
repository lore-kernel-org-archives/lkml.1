Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZDMSOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZDMSOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZDMSOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:14:46 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:46349 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZDMSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:14:45 -0400
Date: Mon, 13 Apr 2009 14:07:58 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <alpine.DEB.2.00.0904071501570.32000@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0904131407370.13756@qirst.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi>
 <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com> <49DBB929.4080205@cs.helsinki.fi> <alpine.DEB.1.10.0904071641390.12192@qirst.com>
 <49DBBC1F.6000407@cs.helsinki.fi> <alpine.DEB.1.10.0904071728240.12192@qirst.com> <alpine.DEB.2.00.0904071445200.27115@chino.kir.corp.google.com> <alpine.DEB.1.10.0904071747400.12192@qirst.com>
 <alpine.DEB.2.00.0904071501570.32000@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, David Rientjes wrote:

> The page allocator may be getting significantly faster, but that is _not_
> the only reason why we use partial slabs.  Higher order slabs, such as the
> default for kmalloc-2048, kmalloc-4096, etc., increase the liklihood of
> having cpu slabs at that order as opposed to order fallback with a
> sufficiently long uptime.

kmalloc-4096 will go away with a faster page allocator.

