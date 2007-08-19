Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbXHSW6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbXHSW6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXHSW6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:58:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51962 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbXHSW6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:58:36 -0400
Date: Sun, 19 Aug 2007 23:58:35 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: convert #include "linux/..." to #include <linux/...> [PATCH]s follow
Message-ID: <20070819225835.GW21089@ftp.linux.org.uk>
References: <1187561864.4200.136.camel@localhost> <Pine.LNX.4.64.0708200031560.19577@fbirervta.pbzchgretzou.qr> <20070819224425.GU21089@ftp.linux.org.uk> <1187563756.4200.167.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187563756.4200.167.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2007 at 03:49:16PM -0700, Joe Perches wrote:
> On Sun, 2007-08-19 at 23:44 +0100, Al Viro wrote:
> > Except that some instances are legitimate (e.g. there was a bunch in
> > arch/um, IIRC)...
> 
> I guess it's a good thing that vger seems to have rejected
> that 140KB patch I sent against arch/um and include/asm-um.

It would be a better thing if you
	* did builds of the patched trees (allmodconfig for uml/i386 and
uml/amd64 in this case)
	* figured out that one can send a reference to branch in git tree
(with summary/shortlog/diffstat) using somewhat less than 140KB...
