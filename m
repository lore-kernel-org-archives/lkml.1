Return-Path: <linux-kernel-owner+w=401wt.eu-S966525AbXILK7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966525AbXILK7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXILK7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:59:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764265AbXILK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:59:23 -0400
Date: Wed, 12 Sep 2007 12:59:15 +0200
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Emil Medve <Emilian.Medve@Freescale.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, i2c@lm-sensors.org,
       linux-omap-open-source@linux.omap.com,
       Emil Medve <Emilian.Medve@Freescale.com>
Subject: Re: [PATCH] Move the definition of pr_err() into kernel.h
Message-ID: <20070912125915.5b5d8aa5@oldman>
In-Reply-To: <11895225651521-git-send-email-Emilian.Medve@Freescale.com>
References: <11895225651521-git-send-email-Emilian.Medve@Freescale.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 09:56:05 -0500
Emil Medve <Emilian.Medve@Freescale.com> wrote:

> Other pr_*() macros are already defined in kernel.h, but pr_err() was defined
> multiple times in several other places
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>

pr_error seems better than pr_err

Please add the full set:
	pr_alert
	pr_critical
        pr_error
        pr_warn
        pr_notice


