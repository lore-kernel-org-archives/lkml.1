Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYEEAe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYEEAe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 20:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYEEAer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 20:34:47 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:53371 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750737AbYEEAeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 20:34:46 -0400
X-Originating-IP: [74.251.4.130]
Date: Sun, 4 May 2008 19:34:42 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Luca Tettamanti <kronos.it@gmail.com>, Chris Snook <csnook@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org
Subject: Re: atl1 64-bit => 32-bit DMA borkage (reproducible, bisected)
Message-ID: <20080504193442.04c9a88a@osprey.hogchain.net>
In-Reply-To: <20080504193128.1ea61958@osprey.hogchain.net>
References: <20080419111719.GA6724@martell.zuzino.mipt.ru>
	<20080419144535.GA4814@martell.zuzino.mipt.ru>
	<20080419215444.2d4623f5@osprey.hogchain.net>
	<20080420111453.GA4902@martell.zuzino.mipt.ru>
	<20080420060607.2b1be48b@osprey.hogchain.net>
	<20080420122631.GA4761@martell.zuzino.mipt.ru>
	<20080420133704.63f5cc10@osprey.hogchain.net>
	<20080420205500.GA4762@martell.zuzino.mipt.ru>
	<20080421210821.28053a92@osprey.hogchain.net>
	<20080425195743.2bfe66ee@osprey.hogchain.net>
	<20080504211507.GC1040@martell.zuzino.mipt.ru>
	<20080504193128.1ea61958@osprey.hogchain.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 19:31:28 -0500
Jay Cliburn <jacliburn@bellsouth.net> wrote:

> All the descriptors, therefore, have to live within the same 4GB address
> space.

Make that "...within the same 2GB address space."
