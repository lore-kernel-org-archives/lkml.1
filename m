Return-Path: <linux-kernel-owner+w=401wt.eu-S965463AbYD1RAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463AbYD1RAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935959AbYD1RAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:00:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933408AbYD1RAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:00:03 -0400
Date: Mon, 28 Apr 2008 09:59:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bzolnier@gmail.com
Subject: Re: 2.6.25-mm1: Failing to probe IDE interface
Message-Id: <20080428095924.3b7dfb96.akpm@linux-foundation.org>
In-Reply-To: <20080428164235.GA29229@csn.ul.ie>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	<20080428164235.GA29229@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 17:42:36 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> An old T21 is failing to boot and the relevant message appears to be
> 
> [    1.929536] Probing IDE interface ide0...
> [   36.939317] ide0: Wait for ready failed before probe !
> [   37.502676] ide0: DISABLED, NO IRQ
> [   37.506356] ide0: failed to initialize IDE interface
> 
> The owner of ide-mm-ide-add-struct-ide_io_ports-take-2.patch with the
> "DISABLED, NO IRQ" message is cc'd. I've attached the config, full boot log
> and lspci -v for the machine in question. I'll start reverting some of the
> these patches to see if ide-mm-ide-add-struct-ide_io_ports-take-2.patch
> is really the culprit.

ide-mm-ide-add-struct-ide_io_ports-take-2.patch is now in mainline so a
quicky confirmation would be to test Linus's tree.

