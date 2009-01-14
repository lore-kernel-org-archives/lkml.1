Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbZANCXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbZANCXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZANCXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:23:04 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:38493 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbZANCXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:23:02 -0500
Date: Tue, 13 Jan 2009 18:22:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [8/7] dst: kconfig update.
Message-Id: <20090113182251.1cda2d64.randy.dunlap@oracle.com>
In-Reply-To: <20090113230943.GA30952@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
	<1231887933-17843-2-git-send-email-zbr@ioremap.net>
	<1231887933-17843-3-git-send-email-zbr@ioremap.net>
	<1231887933-17843-4-git-send-email-zbr@ioremap.net>
	<1231887933-17843-5-git-send-email-zbr@ioremap.net>
	<1231887933-17843-6-git-send-email-zbr@ioremap.net>
	<1231887933-17843-7-git-send-email-zbr@ioremap.net>
	<1231887933-17843-8-git-send-email-zbr@ioremap.net>
	<20090113230943.GA30952@ioremap.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.496D4C7E.0028:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 02:09:43 +0300 Evgeniy Polyakov wrote:

> On Wed, Jan 14, 2009 at 02:05:33AM +0300, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> > --- /dev/null
> > +++ b/drivers/staging/dst/Kconfig
> > @@ -0,0 +1,71 @@
> > +config DST
> > +	tristate "Distributed storage"
> > +	depends on NET && CRYPTO && SYSFS
> > +	select CONNECTOR
> > +	select LIBCRC32C
> 
> Above is not needed.
> 
> --- ./drivers/staging/dst/Kconfig.old	2009-01-14 02:09:52.000000000 +0300
> +++ ./drivers/staging/dst/Kconfig	2009-01-14 02:10:02.000000000 +0300
> @@ -2,14 +2,10 @@
>  	tristate "Distributed storage"
>  	depends on NET && CRYPTO && SYSFS
>  	select CONNECTOR
> -	select LIBCRC32C
>  	---help---
>  	DST is a network block device storage, which can be used to organize
>  	exported storages on the remote nodes into the local block device.
>  
> -	DST is a network block device storage, which can be used to organize
> -	exported storages on the remote nodes into the local block device.
> -
>  	DST works on top of any network media and protocol, it is just a matter
>  	of configuration utility to understand the correct addresses. The most
>  	common example is TCP over IP allows to pass through firewalls and

ah, i see.

---
~Randy
