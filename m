Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYHOJaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYHOJaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYHOJ34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:29:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbYHOJ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:29:55 -0400
Subject: Re: [PATCH 1/1] MTD Maps: initial driver for using gpios to assist
	in addressing of parallel flash as is on the tinyboards
From: David Woodhouse <dwmw2@infradead.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <1218789421-9995-1-git-send-email-cooloney@kernel.org>
References: <1218789421-9995-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 10:29:53 +0100
Message-Id: <1218792593.3184.71.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 16:37 +0800, Bryan Wu wrote:
> +#define pr_devinit(fmt, args...) ({ static const __devinitconst char
> __fmt[] = fmt; printk(__fmt, ## args); })

You've added that macro twice in MTD code already -- and now you're
adding it twice more (although I suspect only one was intentional).
Where are we with putting it in include/linux/ where it belongs?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



