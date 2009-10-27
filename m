Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZJ0PXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZJ0PXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZJ0PXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:23:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48671 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752361AbZJ0PXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:23:48 -0400
Date: Tue, 27 Oct 2009 15:25:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ghaskins@novell.com, linux-kernel@vger.kernel.org
Subject: Zillions of warnings in -next
Message-ID: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was thinking "what a lot of new warnings". Then I dug a little deeper
and it seems that someone never bothered to try and build
drivers/net/vbus-enet.c on a 32bit system.

So would you mind fixing the 27 new warnings introduced ?

Alan
