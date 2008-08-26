Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYHZUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYHZUuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYHZUua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:50:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33923
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbYHZUu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:50:29 -0400
Date: Tue, 26 Aug 2008 13:50:24 -0700 (PDT)
Message-Id: <20080826.135024.03095891.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-parisc@vger.kernel.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: __kernel_suseconds_t is int on PA-RISC (and SPARC64)?
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808262207450.7910@anakin>
References: <Pine.LNX.4.64.0808262207450.7910@anakin>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 26 Aug 2008 22:11:25 +0200 (CEST)

> Apparently __kernel_suseconds_t is `int' on PA-RISC (and on SPARC64),
> while it's `long' on all other platforms.
> 
> Is there a specific reason for that?

An existing API probably decided it for us :-)

Anyways, no use in wondering why, it can't be changed at this point.
