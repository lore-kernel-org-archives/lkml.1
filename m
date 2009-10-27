Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZJ0BTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZJ0BTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZJ0BS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:18:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48335
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbZJ0BS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:18:59 -0400
Date: Mon, 26 Oct 2009 18:19:22 -0700 (PDT)
Message-Id: <20091026.181922.261475236.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: phdm@macqel.be, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ide] : Increase WAIT_DRQ to support slow CF cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <51f3faa70910261807h54f05f73j48b67067ee3dde70@mail.gmail.com>
References: <4AE64031.5060105@gmail.com>
	<20091026.174525.154760254.davem@davemloft.net>
	<51f3faa70910261807h54f05f73j48b67067ee3dde70@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Mon, 26 Oct 2009 19:07:18 -0600

> libata only busy-waits for 50 microseconds, if not set then it sleeps
> for 2ms and polls for another 10 microseconds, if still not set it
> tries the whole thing again at 16ms intervals. Only after (typically)
> 30 seconds does it give up.

Porting that kind of logic over to IDE is a non-starter.

It's easier to get people to move over to using the ATA layer for
their devices.

Meanwhile we should provide a way for things to work, and
realistically the only way to do that currently is to bump the
WAIT_DRQ value to some large number.

And that's exactly the kind of patch I'm willing to accept for this.
