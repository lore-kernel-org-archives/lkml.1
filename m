Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZBTP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZBTP1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZBTP1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:27:38 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:55313 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZBTP1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:27:37 -0500
Date: Sat, 21 Feb 2009 00:27:35 +0900 (JST)
Message-Id: <20090221.002735.27955033.anemo@mba.ocn.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       jason.wessel@windriver.com
Subject: Re: [PATCH resend] kgdb: kgdboc console poll hooks for serial_txx9
 uart
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090219131758.088381f3.akpm@linux-foundation.org>
References: <20090218.223641.128619445.anemo@mba.ocn.ne.jp>
	<20090219131758.088381f3.akpm@linux-foundation.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 13:17:58 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > +	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
> 
> It's nicer to use container_of() for this operation.

While there are same casts in the driver already, I will send another
patch to convert them at once.

Thank you.
