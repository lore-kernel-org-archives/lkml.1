Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXDLQZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXDLQZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXDLQZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:25:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36084 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbXDLQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:25:47 -0400
Date: Thu, 12 Apr 2007 17:28:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070412172845.58bfeff5@the-village.bc.nu>
In-Reply-To: <461E55C6.1030905@theshore.net>
References: <461E55C6.1030905@theshore.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There are userspace solutions to this problem:  allowing the 
> uncompressed core dump to spin out to disk and then coming in afterwards 
> and doing the compression, or maybe even a compressed filesystem where 
> the core dumps land, but I just thought I'd throw this out there since 
> it seems it would be a useful feature :)

Indeed. So useful that in current kernels you can set the core dump path
to be

	"|application"

and it will call out to the helper. Take care with the helper as it will
get run for setuid apps, roots core dumps etc.

Alan
