Return-Path: <linux-kernel-owner+w=401wt.eu-S1422953AbXBHMKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953AbXBHMKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422956AbXBHMKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:10:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38730
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1422953AbXBHMKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:10:07 -0500
Date: Thu, 08 Feb 2007 04:10:04 -0800 (PST)
Message-Id: <20070208.041004.07457320.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: checker-shell still hosed...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070208.030531.112264703.davem@davemloft.net>
References: <20070208.030531.112264703.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 08 Feb 2007 03:05:31 -0800 (PST)

> define test1
>   $(shell echo "str1")
> endef
> 
> define test2
>   $(call test1)
> endef

Someone just privately explained that my test case is broken
because of the spaces before the "$(shell " in the defines.
Removing them makes the spaces go away.
