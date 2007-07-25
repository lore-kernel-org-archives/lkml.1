Return-Path: <linux-kernel-owner+w=401wt.eu-S1763204AbXGYMlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763204AbXGYMlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXGYMkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:40:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48820 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbXGYMky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:40:54 -0400
Message-ID: <46A744D1.3070300@fr.ibm.com>
Date: Wed, 25 Jul 2007 14:40:49 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/

found that one on ppc,

drivers/char/hw_random/pasemi-rng.c:140: error: unknown field 'type' specified in initializer
drivers/char/hw_random/pasemi-rng.c:140: warning: initialization makes pointer from integer without a cast

hwrng-add-type-categories.patch modifies a struct of the wrong type.

the pasemi-rng driver registers a 'of_platform_driver' not a 'hwrng'.

cheers,

C.
