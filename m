Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbXDXEfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbXDXEfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXDXEfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:35:45 -0400
Received: from gw.goop.org ([64.81.55.164]:44518 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbXDXEfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:35:44 -0400
Message-ID: <462D893A.1020201@goop.org>
Date: Mon, 23 Apr 2007 21:36:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: ak@suse.de, chrisw@sous-sol.org, virtualization@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/25] xen: Lockdep fixes for xen-netfront
References: <E1HgBbr-0007Ob-00@gondolin.me.apana.org.au>
In-Reply-To: <E1HgBbr-0007Ob-00@gondolin.me.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> You don't need to disable BH in netif_poll since it's always called
> with BH disabled.
>   

Ah, yes, you mentioned that before.  I'll fix it up.

    J
