Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZFRVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZFRVJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZFRVJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:09:25 -0400
Received: from local.xorcom.com ([62.90.10.53]:40755 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbZFRVJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:09:24 -0400
Date: Fri, 19 Jun 2009 00:09:25 +0300
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: Open Source Line Echo Canceller 
	<freetel-oslec@lists.sourceforge.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [freetel-oslec] [PATCH] fix Pstate growing in OSLEC
Message-ID: <20090618210925.GU3311@xorcom.com>
References: <20090618174540.GT3311@xorcom.com> <1245358446.6714.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245358446.6714.3.camel@localhost>
X-Forced-Service: Sadly Using Gmail [tm]
Organization: Xorcom*
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 06:24:06AM +0930, David Rowe wrote:

> Re gathering dust, on the contrary I understand that many people are
> using Oslec from the kernel staging directory with the Asterisk DAHDI
> interface.

... and thus creating interesting artifacts such as:

  http://svn.asterisk.org/svn/dahdi/linux/trunk/drivers/dahdi/dahdi_echocan_oslec.c
  http://svn.asterisk.org/svn/dahdi/linux/trunk/drivers/dahdi/Kbuild
  https://issues.asterisk.org/view.php?id=15251

Note the line '#include "../staging/echo/oslec.h"

-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
