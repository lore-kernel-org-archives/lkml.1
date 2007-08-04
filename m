Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbXHDTn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbXHDTn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765246AbXHDTnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:43:50 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55559 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761966AbXHDTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:43:49 -0400
Subject: Re: [PATCH][RESEND] Fix a potential NULL pointer deref in the
	aic7xxx, ahc_print_register() function
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <jejb@kernel.org>, linux-scsi@vger.kernel.org,
       "Justin T. Gibbs" <gibbs@scsiguy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200708042030.52405.jesper.juhl@gmail.com>
References: <200708042030.52405.jesper.juhl@gmail.com>
Content-Type: text/plain
Date: Sat, 04 Aug 2007 14:43:47 -0500
Message-Id: <1186256627.3439.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 20:30 +0200, Jesper Juhl wrote:
> (resend of patch previously submitted on 28-Jul-2007 23:06)
> 
> 
> Ehlo,
> 
> The Coverity checker noticed that we have a potential NULL pointer 
> deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
> This patch handles it by adding the same test against NULL that is 
> used elsewhere in the same function.

It's on my list of things to look at ... but not very high.  I suspect
it actually isn't triggerable, but if you can tell me how, it will save
me from looking.

James


