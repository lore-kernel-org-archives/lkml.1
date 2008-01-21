Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYAUAIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYAUAIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYAUAHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:07:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54340
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbYAUAHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:07:53 -0500
Date: Sun, 20 Jan 2008 16:07:58 -0800 (PST)
Message-Id: <20080120.160758.160048986.davem@davemloft.net>
To: ak@suse.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
From: David Miller <davem@davemloft.net>
In-Reply-To: <200801202053.30386.ak@suse.de>
References: <200801202053.30386.ak@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Sun, 20 Jan 2008 20:53:30 +0100

> 
> My workstation running 2.6.24-rc8 just hung during shutdown with an endless 
> (or rather I didn't wait more than a few minutes) loop of 
> 
> unregister_netdev: waiting for ppp-device to become free. Usage count = 1
> 
> ppp-device was an active PPPoE device.
> 
> No more information currently.

http://bugzilla.kernel.org/show_bug.cgi?id=9778
