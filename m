Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZC3GiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZC3GiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZC3GiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:38:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54747 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZC3GiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:38:14 -0400
Subject: Re: [patch 0/3] slub partial list thrashing performance degradation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
Date: Mon, 30 Mar 2009 09:38:11 +0300
Message-Id: <1238395091.26742.24.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 22:43 -0700, David Rientjes wrote:
> SLUB causes a performance degradation in comparison to SLAB when a
> workload has an object allocation and freeing pattern such that it spends
> more time in partial list handling than utilizing the fastpaths.

Christoph, Nick, any objections to merging this? The patches look sane
and the numbers convincing enough to me.

			Pekka

