Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZAMXKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZAMXKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbZAMXJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:09:46 -0500
Received: from tservice.ru ([195.178.208.66]:34418 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbZAMXJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:09:45 -0500
Date: Wed, 14 Jan 2009 02:09:43 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: [8/7] dst: kconfig update.
Message-ID: <20090113230943.GA30952@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <1231887933-17843-5-git-send-email-zbr@ioremap.net> <1231887933-17843-6-git-send-email-zbr@ioremap.net> <1231887933-17843-7-git-send-email-zbr@ioremap.net> <1231887933-17843-8-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231887933-17843-8-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:05:33AM +0300, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> --- /dev/null
> +++ b/drivers/staging/dst/Kconfig
> @@ -0,0 +1,71 @@
> +config DST
> +	tristate "Distributed storage"
> +	depends on NET && CRYPTO && SYSFS
> +	select CONNECTOR
> +	select LIBCRC32C

Above is not needed.

--- ./drivers/staging/dst/Kconfig.old	2009-01-14 02:09:52.000000000 +0300
+++ ./drivers/staging/dst/Kconfig	2009-01-14 02:10:02.000000000 +0300
@@ -2,14 +2,10 @@
 	tristate "Distributed storage"
 	depends on NET && CRYPTO && SYSFS
 	select CONNECTOR
-	select LIBCRC32C
 	---help---
 	DST is a network block device storage, which can be used to organize
 	exported storages on the remote nodes into the local block device.
 
-	DST is a network block device storage, which can be used to organize
-	exported storages on the remote nodes into the local block device.
-
 	DST works on top of any network media and protocol, it is just a matter
 	of configuration utility to understand the correct addresses. The most
 	common example is TCP over IP allows to pass through firewalls and


-- 
	Evgeniy Polyakov
