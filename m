Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbXI2NwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbXI2NwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXI2NwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 09:52:13 -0400
Received: from ozlabs.org ([203.10.76.45]:38879 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbXI2NwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 09:52:13 -0400
Subject: Re: [PATCH] module: return error when mod_sysfs_init() failed
From: Rusty Russell <rusty@rustcorp.com.au>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20070929100653.GA4121@APFDCB5C>
References: <20070929100653.GA4121@APFDCB5C>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 23:51:49 +1000
Message-Id: <1191073909.26950.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-29 at 19:06 +0900, Akinobu Mita wrote:
> load_module() returns zero when mod_sysfs_init() fails,
> then the module loading will succeed accidentally.
> 
> This patch makes load_module() return error correctly in that case.

Thanks, applied.

Cheers,
Rusty.


