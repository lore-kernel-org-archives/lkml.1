Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXHSWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXHSWdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXHSWdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:33:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43587 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXHSWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:33:22 -0400
Date: Mon, 20 Aug 2007 00:33:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: convert #include "linux/..." to #include <linux/...> [PATCH]s
 follow
In-Reply-To: <1187561864.4200.136.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708200031560.19577@fbirervta.pbzchgretzou.qr>
References: <1187561864.4200.136.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 19 2007 15:17, Joe Perches wrote:
>There are several files that:
>
>#include "linux/file" not #include <linux/file>
>#include "asm/file" not #include <asm/file>

Not only that. All directories in include should be checked against
(e.g. <net/*>)


	Jan
-- 
