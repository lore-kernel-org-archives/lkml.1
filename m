Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXKIEge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXKIEge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 23:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbXKIEgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 23:36:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKIEgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 23:36:22 -0500
Date: Thu, 8 Nov 2007 20:35:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       marcelo@kvack.org, scottwood@freescale.com, jeff@garzik.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Fix typo #ifdef -> #ifndef
Message-Id: <20071108203552.bcc1e5a8.akpm@linux-foundation.org>
In-Reply-To: <472CC914.3030709@scram.de>
References: <472CC914.3030709@scram.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 03 Nov 2007 20:16:36 +0100 Jochen Friedrich <jochen@scram.de> wrote:
> Subject: [PATCH] [POWERPC] Fix typo #ifdef -> #ifndef

Please put the "powerpc" outside the [].  Because things inside [] get
removed when the receiver applies the patch, but the subsystem
identification ("powerpc") is useful information which we want to carry
into the permanent git record. (Although Paul might add it anyway - some
git tree maintainers do).

> User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)

This seems to be setting a record for MUA vandalism.  Leading spaces were
removed and various esoteric whitespace transformations were made.  The
diffs were small so I fixed them by hand.

Please strangle your email client.

