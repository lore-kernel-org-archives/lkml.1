Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZGTX0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZGTX0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZGTX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:26:51 -0400
Received: from relay2.sgi.com ([192.48.179.30]:53713 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754378AbZGTX0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:26:51 -0400
Date: Mon, 20 Jul 2009 18:26:49 -0500
From: Jack Steiner <steiner@sgi.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-gru: Fix kernel stack buffer overrun
Message-ID: <20090720232649.GA5009@sgi.com>
References: <200907210008.38990.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907210008.38990.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:08:38AM +0200, Michael Buesch wrote:
> This patch fixes a kernel stack buffer overrun in the sgi-gru procfs
> interface implementation.
> The "count" parameter to options_write() is user controlled. So this bug
> can be used to write '\0' bytes to almost arbitrary places on the kernel stack.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Cc: stable@kernel.org

Acked-by: Jack Steiner <steiner@sgi.com>


Thanks...

--- jack
