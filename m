Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXJVOLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXJVOLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbXJVOLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:11:24 -0400
Received: from rtr.ca ([76.10.145.34]:4430 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbXJVOLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:11:23 -0400
Message-ID: <471CAF88.2010806@rtr.ca>
Date: Mon, 22 Oct 2007 10:11:20 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression:  2.6.23-rc9 okay, 2.6.23.1 resume problems
References: <4712786B.3040009@rtr.ca> <47128C2C.5060502@rtr.ca> <471536E2.9040508@rtr.ca> <200710170207.02732.rjw@sisk.pl>
In-Reply-To: <200710170207.02732.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

What happens to the jiffies variable on resume from RAM, and from DISK?
Do we restore it to the value it had at suspend,
or just leave it be with whatever?

The answer has to be "restore the value it had at suspend time",
but I figured I'd check here anyway.

??
