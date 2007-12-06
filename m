Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbXLFWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbXLFWkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXLFWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:40:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44060 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbXLFWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:40:13 -0500
Date: Thu, 6 Dec 2007 23:40:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Anderson <anderson@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [NEW-PATCH] exec: allow > 2GB executables to run on 64-bit systems
Message-ID: <20071206224011.GI20595@one.firstfloor.org>
References: <4756C590.9080301@redhat.com> <p73fxyhj5f7.fsf@bingen.suse.de> <475702E7.1000607@redhat.com> <20071205195637.GA20595@one.firstfloor.org> <47570B0A.6040404@redhat.com> <20071206221520.GG20595@one.firstfloor.org> <47587995.4000403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47587995.4000403@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks Andi -- I just tested open_exec() w/O_LARGEFILE on an
> i386 with a 2.5GB+ binary (mostly debuginfo), and it works as
> expected.  Interesting to note that the test binary couldn't
> be compiled with i386 gcc, but it could be built with x86_64
> gcc -m32.

I guess the i386 binutils or gcc don't use O_LARGEFILE. They probably
just need to be rebuilt with -D_FILE_OFFSET_BITS=64

-Andi

> 
