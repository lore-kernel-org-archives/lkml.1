Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYE3PQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYE3PQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYE3PQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:16:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYE3PQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:16:45 -0400
Subject: Re: [PATCH] kaweth: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
In-Reply-To: <200805301555.59327.oliver@neukum.org>
References: <1211708969@pmac.infradead.org>
	 <1212070841.26088.28.camel@shinybook.infradead.org>
	 <200805301555.59327.oliver@neukum.org>
Content-Type: text/plain
Date: Fri, 30 May 2008 18:16:37 +0300
Message-Id: <1212160598.8199.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 15:55 +0200, Oliver Neukum wrote:
> Am Donnerstag, 29. Mai 2008 16:20:41 schrieb David Woodhouse:
> >                 if ((result = kaweth_download_firmware(kaweth,
> > -                                                     kaweth_trigger_code_fix,
> > -                                                     len_kaweth_trigger_code_fix,
> > +                                                     "kaweth/trigger_code_fix.bin",
> 
> We don't put hirarchy policy into drivers.

Not a strictly accurate observation; we've been doing so for some time.

-- 
dwmw2

