Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYE1ElN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYE1ElN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 00:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYE1Ek6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 00:40:58 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:38990 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYE1Ek6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 00:40:58 -0400
X-Greylist: delayed 1888 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 00:40:57 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200805280409.m4S498N8008049@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: autload module on Lifebook P1510D
To: dcbw@redhat.com (Dan Williams)
Date: Wed, 28 May 2008 13:39:08 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au, linux-kernel@vger.kernel.org
In-Reply-To: <1211564660.11020.1.camel@localhost.localdomain> from "Dan Williams" at May 23, 2008 01:44:20 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> Put a [PATCH] in the title so people will care...
> 
> diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
> index e2e7c05..6d14e8f 100644
> --- a/drivers/misc/fujitsu-laptop.c
> +++ b/drivers/misc/fujitsu-laptop.c
> @@ -352,3 +352,9 @@ MODULE_AUTHOR("Jonathan Woithe");
>  MODULE_DESCRIPTION("Fujitsu laptop extras support");
>  MODULE_VERSION(FUJITSU_DRIVER_VERSION);
>  MODULE_LICENSE("GPL");
> +
> +static struct pnp_device_id pnp_ids[] = {
> +	{ .id = "FUJ02bf" },
> +	{ .id = "" }
> +};
> +MODULE_DEVICE_TABLE(pnp, pnp_ids);

Ack.

jonathan
