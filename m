Return-Path: <linux-kernel-owner+w=401wt.eu-S1762764AbZCaR2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762764AbZCaR2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZCaR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:28:44 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:51065 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbZCaR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:28:43 -0400
Date: Tue, 31 Mar 2009 13:24:22 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.2.00.0903311014140.10407@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903311323040.1912@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301026580.13333@qirst.com> <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903301718080.25929@qirst.com> <alpine.DEB.2.00.0903301545200.30928@chino.kir.corp.google.com> <alpine.DEB.2.00.0903302140250.27065@chino.kir.corp.google.com> <alpine.DEB.1.10.0903310925130.24040@qirst.com>
 <alpine.DEB.2.00.0903311014140.10407@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, David Rientjes wrote:

> I'd agree that it should be cleared if the tunable had object units
> instead of a ratio, but the ratio simply applies to any given order.

Right but resetting the order usually has a significant impact on the
threashing behavior (if it exists). Why would we keep the threshing ratio
that was calculated for another slab configuration?

