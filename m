Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZGMQJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZGMQJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZGMQJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:09:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45746 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756458AbZGMQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:09:04 -0400
Subject: Re: [PATCH] Fix vc_screenbuf leak via con_init()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090713145451.GA2265@cmpxchg.org>
References: <20090713130921.6441.17011.stgit@pc1117.cambridge.arm.com>
	 <1247493898.14968.0.camel@penberg-laptop>
	 <20090713145451.GA2265@cmpxchg.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 13 Jul 2009 17:08:17 +0100
Message-Id: <1247501297.22320.21.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2009 16:08:18.0957 (UTC) FILETIME=[230E4BD0:01CA03D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 16:54 +0200, Johannes Weiner wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 13 Jul 2009 16:39:46 +0200
> Subject: [patch] vt: drop bootmem/slab memory distinction
> 
> Bootmem is not used for the vt screen buffer anymore as slab is now
> available at the time the console is initialized.
> 
> Get rid of the now superfluous distinction between slab and bootmem,
> it's always slab.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Catalin Marinas <catalin.marinas@arm.com>

Tested-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

