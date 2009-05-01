Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbZEAJU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbZEAJU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZEAJUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:20:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33270 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbZEAJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:20:47 -0400
Date: Fri, 1 May 2009 10:20:27 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/27] add generic lib/checksum.c
Message-ID: <20090501092027.GA29366@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	Michal Simek <monstr@monstr.eu>,
	Remis Lima Baima <remis.developer@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <cda5746ab12cf9d6bcb7803a3667c92250a29784.1241105648.git.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cda5746ab12cf9d6bcb7803a3667c92250a29784.1241105648.git.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 03:30:31PM +0200, Arnd Bergmann wrote:
> +/*
> + * copy from fs while checksumming, otherwise like csum_partial
> + */
> +__wsum
> +csum_partial_copy_from_user(const void __user *src, void *dst, int len,
> +						__wsum sum, int *csum_err)
> +{
> +	if (csum_err)
> +		*csum_err = 0;
> +	memcpy(dst, src, len);

Since when has 'memcpy' been valid from user addresses?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
