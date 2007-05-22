Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXEVEix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXEVEix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXEVEiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:38:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34454 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbXEVEip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:38:45 -0400
Date: Tue, 22 May 2007 13:39:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce
 buffer logic.
Message-Id: <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 21:03:40 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> The bounce buffer logic is included on systems that do not need it.
> If a system does not have zones like ZONE_DMA and ZONE_HIGHMEM that
> can lead to the use of bounce buffers then there is no need to reserve 
> memory pools etc etc. This is true f.e. for SGI Altix.

> +config BOUNCE
> +	def_bool y
> +	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
> +

AFAIK, ppc has only ZONE_DMA and it never needs bounce.
Is this ok ?

-Kame

