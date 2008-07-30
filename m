Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYG3WSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYG3WSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYG3WS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:18:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60760
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbYG3WS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:18:27 -0400
Date: Wed, 30 Jul 2008 15:18:26 -0700 (PDT)
Message-Id: <20080730.151826.58205352.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: tony.luck@intel.com, jgarzik@redhat.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, netdev@vger.kernel.org, matthew@wil.cx,
       holt@sgi.com, linux-net-drivers@solarflare.com
Subject: Re: [Patch] fix ia64 build failure when CONFIG_SFC=m
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080730133527.GI10471@solarflare.com>
References: <20080729174839.GG10471@solarflare.com>
	<20080729.140040.72089155.davem@davemloft.net>
	<20080730133527.GI10471@solarflare.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Wed, 30 Jul 2008 14:35:29 +0100

> So far as I can see, hardly anyone is doing routing at 10G speeds on Linux.
> If they were, the horrible interaction with LRO would presumably have been
> found and fixed earlier.

This assumes a precise intersection between those doing 10G routing
and their using chips with LRO capable drivers.

All of the 10G equipment I have here and do testing on use drivers
that lack LRO support.
