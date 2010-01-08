Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584Ab0AHPjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0AHPjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465Ab0AHPjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:39:03 -0500
Received: from lazybastard.de ([212.112.238.170]:39013 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0AHPjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:39:01 -0500
Date: Fri, 8 Jan 2010 16:21:22 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/9] MTD: create lockless versions of {get,put}_mtd_device
Message-ID: <20100108152119.GB31872@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop> <1262963198.12577.16.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1262963198.12577.16.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 January 2010 17:06:38 +0200, Maxim Levitsky wrote:
>
> +	err = __get_mtd_device(ret);

Function is called here, afaics not declared and defined...

> [...]
> +int __get_mtd_device(struct mtd_info *mtd)

...further below.  Didn't gcc complain about this?  Or am I missing
something?

Jörn

-- 
Luck is when opportunity meets good preparation.
-- Chinese proverb
