Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbXEUEwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbXEUEwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbXEUEvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:51:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57609 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbXEUEvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:51:53 -0400
Date: Mon, 21 May 2007 06:52:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Factor out common MODULE_INFO content from module*.h files.
Message-ID: <20070521045249.GA30018@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain> <20070520191552.GA25200@uranus.ravnborg.org> <Pine.LNX.4.64.0705201555470.18338@localhost.localdomain> <20070520205116.GB25339@uranus.ravnborg.org> <Pine.LNX.4.64.0705201651570.19270@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705201651570.19270@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> under the circumstances, is there *any* cleanup worth doing WRT to
> this issue?  because of the fact that module.h currently includes
> moduleparam.h, developers have been able to get away with being
> incredibly sloppy in their includes.

It is wortwhile to make module.h independent of moduleparam.h.
The MODULE_INFO stuff has nothing to do with module parameters.

But keep the include so you do not break the > 500 drivers.

	Sam
