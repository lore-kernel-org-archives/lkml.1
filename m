Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYKMMzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYKMMzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYKMMzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:55:22 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:63767 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYKMMzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:55:21 -0500
Date: Thu, 13 Nov 2008 21:55:27 +0900 (JST)
Message-Id: <20081113.215527.74566391.anemo@mba.ocn.ne.jp>
To: sshtylyov@ru.mvista.com
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: remove chipset type fixup from
 ide_host_register()
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <491B5DA4.3020405@ru.mvista.com>
References: <200811122215.15671.bzolnier@gmail.com>
	<491B5DA4.3020405@ru.mvista.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 01:50:12 +0300, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> > * Set chipset type explicitly in tx4938ide and tx4939ide host drivers
> >   (all other host drivers were updated already).
> >
> > * Remove no longer used chipset type fixup from ide_host_register().
...
>    I'm not really sure those are "generic".

Of course those are "generic" as they don't need any special hacks in
ide core :-)

Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
