Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXHaEjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXHaEjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXHaEjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:39:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40486
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753982AbXHaEjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:39:02 -0400
Date: Thu, 30 Aug 2007 21:39:01 -0700 (PDT)
Message-Id: <20070830.213901.48806818.davem@davemloft.net>
To: byron.bbradley@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
From: David Miller <davem@davemloft.net>
In-Reply-To: <fb80ve$i5q$1@sea.gmane.org>
References: <fb80ve$i5q$1@sea.gmane.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byron Bradley <byron.bbradley@gmail.com>
Date: Fri, 31 Aug 2007 03:12:46 +0000 (UTC)

> Anybody got any ideas of how we fix this?

I don't know how much testing XFS gets on ARM, but one thing that some
ARM chips have is D-cache aliasing problems and one thing XFS uses a
lot is virtual remapping of various data structures via vmap().

This might be what is causing the problems.
