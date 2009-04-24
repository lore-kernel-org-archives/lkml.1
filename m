Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZDXPW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZDXPW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZDXPWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:22:19 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:51819 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZDXPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:22:18 -0400
Date: Fri, 24 Apr 2009 11:13:32 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab tree boot failure
In-Reply-To: <20090425005206.943530b6.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0904241112150.7258@qirst.com>
References: <20090425005206.943530b6.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009, Stephen Rothwell wrote:

> The last few days linux-next trees have failed to boot on one of our
> PowerPC Power6 servers.  The partial boot log looks like this (full
> log below):

PowerPc has weird boot requirements like bootstrap from a node != 0 and
unavailability of node 0. This has always been a challenge for
bootstrapping any of the slab allocators.
