Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYKJVTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYKJVTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYKJVSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:18:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:35958 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYKJVSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:18:53 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <F0EE8017-D08B-4520-9017-ED99B54C6703@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Trent Piepho <tpiepho@freescale.com>
In-Reply-To: <1226351361-27115-1-git-send-email-tpiepho@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] powerpc: Repair device bindings documentation
Date: Mon, 10 Nov 2008 15:18:12 -0600
References: <1226351361-27115-1-git-send-email-tpiepho@freescale.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 10, 2008, at 3:09 PM, Trent Piepho wrote:

> Commit d0fc2eaaf4c56a95f5ed29b6bfb609e19714fc16 "powerpc/fsl: Refactor
> device bindings" split out a number of device bindings from
> booting-without-of.txt into separate files.  Having them all in one  
> file
> was a frequent source of merge conflicts.
>
> However, in the next merge,  
> 49997d75152b3d23c53b0fa730599f2f74c92c65, there
> was another conflict.  Some of the bindings removed from
> booting-without-of.txt were mistakenly added back in and the copies in
> dts-bindings were kept as well.
>
> This patch re-removes "Freescale Display Interface" and "Freescale  
> on board
> FPGA" and fixes the table of contents.
>
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> Acked-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>
> Maybe this should go in 2.6.28, since it fixes a doc bug and before
> anyone modifies the version of the docs that should have been deleted.
>
> Documentation/powerpc/booting-without-of.txt |   65 +++ 
> +----------------------
> 1 files changed, 10 insertions(+), 55 deletions(-)

applied to merge

- k
