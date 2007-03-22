Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXCVXWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXCVXWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXCVXWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:22:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604AbXCVXWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:22:17 -0400
Date: Thu, 22 Mar 2007 16:20:11 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-Id: <20070322162011.9c6e2a88.zaitcev@redhat.com>
In-Reply-To: <4602FB7D.4070908@redhat.com>
References: <20070322085451.GB10598@dose.home.local>
	<Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org>
	<20070322195448.GA17521@dose.home.local>
	<200703221429.12029.david-b@pacbell.net>
	<4602FB7D.4070908@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 17:56:13 -0400, Chuck Ebbert <cebbert@redhat.com> wrote:

> >>> 	  _Something_ is generating those overcurrent 
> >>> warnings, and it sure looks like a hardware malfunction.

> >> But it works with 2.6.20.

> Generation 1 iPod Shuffle is notorious for high current draw.
> You should be able to get the 512MB model really really cheap
> by now.

That's true but the 2.6.20 works, right? That's what we're looking
at here.

The problem is in the device, true, but this is why Tino is the only
one who can bisect and find what we did to aggravate the problem.

-- Pete
