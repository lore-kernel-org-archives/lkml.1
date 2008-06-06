Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYFFQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYFFQH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYFFQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:07:10 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:53115 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYFFQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:07:09 -0400
Message-Id: <200806061606.m56G6kiH008958@cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
cc: Giuliano Procida <gprocida@marge.com>,
       linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Reply-To: chas3@users.sourceforge.net
Reply-To: chas3@users.sourceforge.net
Reply-To: chas3@users.sourceforge.net
Subject: Re: [PATCH] firmware: convert Ambassador ATM driver to request_firmware()
In-reply-to: <1212690489.32207.285.camel@pmac.infradead.org>
Date: Fri, 06 Jun 2008 12:06:46 -0400
X-NRLCMF-Spam-Score: () hits=-0.115
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1212690489.32207.285.camel@pmac.infradead.org>,David Woodhouse writ
es:
>On Thu, 2008-06-05 at 14:20 -0400, Chas Williams (CONTRACTOR) wrote:
>> it would need to be converted to the binary form first, or the patch
>> will need to rewritten to use the s-record format.
>
>We can do binary form. We just run it through objcopy -Ibinary -Oihex
>for convenience of handling it (and that's different to the ones we
>actually hand to the kernel in the form of records).

i guess whatever you want to do.  it is just as easy to distribute
the firmware with the atm tools.  it would also ease your gpl concerns
which you noted in your first message.
