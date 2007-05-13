Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbXEMXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbXEMXVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbXEMXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:21:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44052
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756321AbXEMXVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:21:09 -0400
Date: Sun, 13 May 2007 16:20:59 -0700 (PDT)
Message-Id: <20070513.162059.78710763.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <4647569D.7010709@imap.cc>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<4647569D.7010709@imap.cc>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sun, 13 May 2007 20:19:09 +0200

> Would it be asking too much to have help texts on the following
> new (wrt 2.6.21) configuration options?
> 
> ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)

This one is a case where the option makes no sense by itself,
it provides the core common code for other front-end drivers.

The documentation exists in those front end drivers, which
in turn auto-matically select and enable this config option.

It would be nice if there was a Kconfig way to not provide
this thing at all unless one of the front-ends got selected
but on the otherhand I like how anyone can select it and thus
test the build of it :-)
