Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYFWDFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYFWDFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYFWDFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:05:07 -0400
Received: from ozlabs.org ([203.10.76.45]:42856 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbYFWDFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:05:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [PATCH] module: reorder struct module to save space on 64 bit builds
Date: Mon, 23 Jun 2008 13:04:31 +1000
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <1213973051.3047.12.camel@castor.localdomain>
In-Reply-To: <1213973051.3047.12.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231304.31879.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008 00:44:11 Richard Kennedy wrote:
> reorder struct module to save space on 64 bit builds.
> saves 1 cacheline_size  (128 on default x86_64 & 64 on AMD
> Opteron/athlon) when CONFIG_MODULE_UNLOAD=y.
>
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Thanks, applied!

Cheers,
Rusty.
