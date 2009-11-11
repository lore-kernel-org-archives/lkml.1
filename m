Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZKKNew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZKKNew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZKKNew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:34:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:32847 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZKKNev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:34:51 -0500
Subject: Re: [PATCH] net/atm: move all compat_ioctl handling to atm/ioctl.c
From: David Woodhouse <dwmw2@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, eric.dumazet@gmail.com
In-Reply-To: <200911111430.44361.arnd@arndb.de>
References: <200911061500.01651.arnd@arndb.de>
	 <20091110.204118.12070030.davem@davemloft.net>
	 <200911111430.44361.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 13:34:50 +0000
Message-ID: <1257946490.25961.1396.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 14:30 +0100, Arnd Bergmann wrote:
> 
> +struct atmif_sioc32 {
> +       compat_int_t    number;
> +       compat_int_t    length;
> +       compat_caddr_t  arg;
> +};
> +
> +struct atm_iobuf32 {
> +       compat_int_t    length;
> +       compat_caddr_t  buffer;
> +}; 

We already have compat_atmif_sioc and compat_atm_iobuf structures
defined -- do those need to be duplicated?

Other than that, it looks sane. I wish I'd noticed that we already had
half a COMPAT implementation when I added the new bits. Thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

