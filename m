Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZA2DBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZA2DBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZA2DBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:01:07 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:42310 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751364AbZA2DBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:01:05 -0500
Date: Thu, 29 Jan 2009 11:57:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and clean up maple bus driver (3/3)
Message-ID: <20090129025754.GC31096@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Greg KH <greg@kroah.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-input <linux-input@vger.kernel.org>,
	MTD <linux-mtd@lists.infradead.org>
References: <1233186456.6734.16.camel@localhost.localdomain> <1233187069.6734.21.camel@localhost.localdomain> <1233187750.6734.27.camel@localhost.localdomain> <1233188287.6734.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233188287.6734.32.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 12:18:07AM +0000, Adrian McMenamin wrote:
> +	if (!(mdev->function & MAPLE_FUNC_KEYBOARD)) {
> +		error = EINVAL;
> +		goto fail;
> +	}
>  
What is this all about? If the function doesn't match, you should never
enter the probe routine in the first place. The bus code should already
get this right.
