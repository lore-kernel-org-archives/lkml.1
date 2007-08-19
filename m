Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXHSWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXHSWoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXHSWo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:44:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54028 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXHSWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:44:28 -0400
Date: Sun, 19 Aug 2007 23:44:25 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: convert #include "linux/..." to #include <linux/...> [PATCH]s follow
Message-ID: <20070819224425.GU21089@ftp.linux.org.uk>
References: <1187561864.4200.136.camel@localhost> <Pine.LNX.4.64.0708200031560.19577@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708200031560.19577@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 12:33:21AM +0200, Jan Engelhardt wrote:
> 
> On Aug 19 2007 15:17, Joe Perches wrote:
> >There are several files that:
> >
> >#include "linux/file" not #include <linux/file>
> >#include "asm/file" not #include <asm/file>
> 
> Not only that. All directories in include should be checked against
> (e.g. <net/*>)

Except that some instances are legitimate (e.g. there was a bunch in
arch/um, IIRC)...
