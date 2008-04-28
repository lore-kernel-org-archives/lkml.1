Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbYD1IyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbYD1IyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYD1IyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:54:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38091
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754484AbYD1IyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:54:15 -0400
Date: Mon, 28 Apr 2008 01:54:14 -0700 (PDT)
Message-Id: <20080428.015414.193700356.davem@davemloft.net>
To: bunk@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig 'depend' vs. 'select'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080428081319.GC16379@cs181133002.pp.htv.fi>
References: <20080428063953.GA2088@cs181133002.pp.htv.fi>
	<20080427.234221.40346351.davem@davemloft.net>
	<20080428081319.GC16379@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 28 Apr 2008 11:13:19 +0300

> The non-modular is only true for "bool selects tristate".
> 
> You are talking about things like:
> 
> config IWL4965_LEDS
>         bool "Enable LEDS features in iwl4965 driver"
>         select LEDS_CLASS
> 
> The problem here is that from a kconfig perspective IWL4965_LEDS could 
> as well be an own driver you want for some reason non-modular.
> 
> The solution is to do the following instead:
> 
> config IWL4965
>         tristate "Intel Wireless WiFi 4965AGN"
> 	select LEDS_CLASS if IWL4965_LEDS

Ok, thanks Adrian.
