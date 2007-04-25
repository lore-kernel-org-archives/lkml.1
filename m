Return-Path: <linux-kernel-owner+w=401wt.eu-S965550AbXDYMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbXDYMb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXDYMb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:31:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:52929 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965522AbXDYMb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:31:26 -0400
Subject: Re: [PATCH 5/5] jffs2: Allow selection of compression mode via a
	sysfs attribute
From: David Woodhouse <dwmw2@infradead.org>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
       linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
In-Reply-To: <1172690034.16062.144.camel@localhost.localdomain>
References: <1172690034.16062.144.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 13:31:20 +0100
Message-Id: <1177504280.2755.212.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 19:13 +0000, Richard Purdie wrote:
> Allow selection of the compression mode for jffs2 via a sysfs 
> attribute. This establishes a sysfs presence for jffs2 through
> which other compression options could easily be exported too. 

And other options like GC threshold and other allocation things. So
perhaps put the sysfs subsystem_register() and other core bits into a
generic (and Linux-specific) file?

-- 
dwmw2

