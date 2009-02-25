Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbZBYVdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbZBYVdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZBYVcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:32:51 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35640 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752892AbZBYVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:32:51 -0500
Date: Wed, 25 Feb 2009 16:23:14 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck
  is enabled
In-Reply-To: <19f34abd0902251117h7a4a6e9ao34e972110d8b40a1@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902251622460.13795@qirst.com>
References: <1235381712.6216.22.camel@penberg-laptop>  <alpine.DEB.1.10.0902231039580.7298@qirst.com>  <1235410406.6216.69.camel@penberg-laptop> <19f34abd0902251117h7a4a6e9ao34e972110d8b40a1@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Vegard Nossum wrote:

> Can you rethink whether SLUB_DEBUG or SLUB_DEBUG_ON is the one we
> really want to depend on !KMEMCHECK, and either submit a new patch or
> convince me that this is sufficient?

!SLUB_DEBUG_ON is the right thing to depend on.

