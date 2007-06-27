Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbXF0Mt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbXF0Mt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbXF0Mtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:49:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:15901 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbXF0Mts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:49:48 -0400
Date: Wed, 27 Jun 2007 14:49:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Trilok Soni <soni.trilok@gmail.com>
cc: apw@uk.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: checkpatch: need space before that '*' (ctx:BxB)
In-Reply-To: <5d5443650706270454v443d1ac7qee6475bc31af844f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706271448430.11120@fbirervta.pbzchgretzou.qr>
References: <5d5443650706270454v443d1ac7qee6475bc31af844f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 27 2007 17:24, Trilok Soni wrote:
>
> In the following case we may not need space before that "(*)". It
> looks like false positive. Please check.
>
> need space before that '*' (ctx:BxB)
> #1034: FILE: drivers/video/omap/omapfb.c:968:
> +       omapfb_nb->nb.notifier_call = (int (*)(struct notifier_block *,
>                                                          ^

The line, as presented in your mail, is already correct
Keep the space between "int" and "(*)"  :-)
[follows how you'd declare a normal variable]


	Jan
-- 
