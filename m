Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZBIPRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZBIPRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZBIPQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:16:55 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:7362 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZBIPQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:16:54 -0500
Date: Mon, 9 Feb 2009 16:16:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, frank@f-seidel.de,
       w.sang@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCHv2 2/2] i2c: adapt debug macros for KERN_* constants
Message-ID: <20090209161644.35e3154d@hyperion.delvare>
In-Reply-To: <498EEA2F.5050601@suse.de>
References: <498C3EEA.5060508@suse.de>
	<498EE9C9.4080002@suse.de>
	<498EEA2F.5050601@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 15:20:31 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the changes to the debug macros in the i2c subsystem
> to meet this requirement. Also changing no-debug statements
> to raw printks again.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/i2c/algos/i2c-algo-pca.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

Applied, thanks.

Wolfram, I would appreciate if you could test the patch and confirm it
doesn't break anything:
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-algo-pca-adapt-debug-macros-for-KERN-constants.patch

Thanks,
-- 
Jean Delvare
