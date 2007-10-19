Return-Path: <linux-kernel-owner+w=401wt.eu-S935656AbXJSRnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935656AbXJSRnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764584AbXJSRmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:42:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757563AbXJSRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:42:53 -0400
Date: Fri, 19 Oct 2007 10:42:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix mm/util.c:krealloc()
In-Reply-To: <20071019140502.GD3778@stusta.de>
Message-ID: <Pine.LNX.4.64.0710191040060.30937@schroedinger.engr.sgi.com>
References: <20071019140502.GD3778@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Adrian Bunk wrote:

> Commit ef8b4520bd9f8294ffce9abd6158085bde5dc902 added one NULL check for 
> "p" in krealloc(), but that doesn't seem to be enough since there 
> doesn't seem to be any guarantee that memcpy(ret, NULL, 0) works 
> (spotted by the Coverity checker).
> 
> For making it clearer what happens this patch also removes the
> pointless min().

Acked-by: Chriustoph Lameter <clameter@sgi.com>
