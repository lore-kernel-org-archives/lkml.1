Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZFSOCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZFSOCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZFSOCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:02:43 -0400
Received: from ozlabs.org ([203.10.76.45]:33219 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZFSOCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:02:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] module: use MODULE_SYMBOL_PREFIX with module_layout
Date: Fri, 19 Jun 2009 23:32:43 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
References: <200906191508.06537.rusty@rustcorp.com.au> <1245397762-13172-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1245397762-13172-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906192332.43672.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009 05:19:22 pm Mike Frysinger wrote:
> The check_modstruct_version() needs to look up the symbol "module_layout"
> in the kernel, but it does so literally and not by a C identifier.  The
> trouble is that it does not include a symbol prefix for those ports that
> need it (like the Blackfin and H8300 port).  So make sure we tack on the
> MODULE_SYMBOL_PREFIX define to the front of it.

Thanks, applied.  I'm surprised this took so long to find.

Rusty.
