Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbZANCWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbZANCWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZANCWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:22:24 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:58029 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbZANCWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:22:23 -0500
Date: Tue, 13 Jan 2009 18:22:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [7/7] dst: kconfig and makefile changes.
Message-Id: <20090113182212.d8cae90d.randy.dunlap@oracle.com>
In-Reply-To: <1231887933-17843-8-git-send-email-zbr@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
	<1231887933-17843-2-git-send-email-zbr@ioremap.net>
	<1231887933-17843-3-git-send-email-zbr@ioremap.net>
	<1231887933-17843-4-git-send-email-zbr@ioremap.net>
	<1231887933-17843-5-git-send-email-zbr@ioremap.net>
	<1231887933-17843-6-git-send-email-zbr@ioremap.net>
	<1231887933-17843-7-git-send-email-zbr@ioremap.net>
	<1231887933-17843-8-git-send-email-zbr@ioremap.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.496D4C57.01D5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 02:05:33 +0300 Evgeniy Polyakov wrote:

> Signed-off-by: Evgeniy Polaykov <zbr@ioremap.net>
> 
> index 0000000..12ffa37
> --- /dev/null
> +++ b/drivers/staging/dst/Kconfig
> @@ -0,0 +1,71 @@
> +config DST
> +	tristate "Distributed storage"
> +	depends on NET && CRYPTO && SYSFS
> +	select CONNECTOR
> +	select LIBCRC32C
> +	---help---
> +	DST is a network block device storage, which can be used to organize
> +	exported storages on the remote nodes into the local block device.
> +
> +	DST is a network block device storage, which can be used to organize
> +	exported storages on the remote nodes into the local block device.
> +

argh.  That paragraph above is still duplicated.  :(
I suppose that you want to emphasize it.

> +	DST works on top of any network media and protocol, it is just a matter
> +	of configuration utility to understand the correct addresses. The most
> +	common example is TCP over IP allows to pass through firewalls and
> +	created remote backup storage in the different datacenter. DST requires
> +	single port to be enabled on the exporting node and outgoing connections
> +	on the local node.


---
~Randy
