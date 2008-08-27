Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYH0XhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYH0XhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbYH0Xg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:36:58 -0400
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:44797 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754447AbYH0Xg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:36:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=aiti+QIYXdLgyy0D1KLX03L+jYTZ8XkP1o+Tsgc4Il5tJ9HwZn2f9U6D2vusaGX+W/ZyBuIPxHd4LJ8vTPvpemaRxgiazpqMxBYUrGWec5KiGL6VewE7NpBrGfTfcEZx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Johann Felix Soden <johfel@gmx.de>
Subject: Re: [PATCH] pci: Fix printk warnings in probe.c
Date: Wed, 27 Aug 2008 16:36:54 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1219430819.7010.5.camel@localhost>
In-Reply-To: <1219430819.7010.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271636.55242.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2008 11:46 am Johann Felix Soden wrote:
> From: Johann Felix Soden <johfel@users.sourceforge.net>
>
> Fix printk format warnings:
> drivers/pci/probe.c: In function 'pci_read_bridge_bases':
> drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long
> unsigned int', but argument 3 has type 'resource_size_t'
> drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long
> unsigned int', but argument 4 has type 'resource_size_t'
> drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long
> unsigned int', but argument 3 has type 'resource_size_t'
> drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long
> unsigned int', but argument 4 has type 'resource_size_t'
> drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long
> unsigned int', but argument 4 has type 'resource_size_t'
> drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long
> unsigned int', but argument 5 has type 'resource_size_t'
>
> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>

I put both of these resource size fixes into my linux-next branch, thanks.

Jesse
