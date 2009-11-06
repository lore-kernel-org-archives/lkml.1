Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZKFAzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZKFAzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZKFAzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:55:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:39861 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZKFAzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:55:36 -0500
Subject: More Huawei modem woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 11:54:59 +1100
Message-ID: <1257468899.13611.254.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan !

>From user reports, it seems that other model of Huawei modems are still
broken in a way that seems very similar to what we observed and fixed
with the E169 but not fixed by the request sense size fix we did.

IE. The initial fix that "enabled" usb-storage to work in 2.6.31.1 broke
them causing them to get into a reset loop due to some issues with
usb-storage.

I've obtained a usbmon log from one of those users with a E620, I would
appreciate if you could have a look as you are a lot better than I am at
parsing those things :-) I attached it to the existing BZ
http://bugzilla.kernel.org/show_bug.cgi?id=14355 .

Of course it's always possible that a whole lot of users have been
testing the wrong kernel and thus don't have the fix :-) But that might
also show a different problem with those modems usb storage
implementation.

Cheers,
Ben.

