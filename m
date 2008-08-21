Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYHUAvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYHUAvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYHUAu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:50:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYHUAu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:50:56 -0400
Date: Wed, 20 Aug 2008 17:50:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc3-git6 busted-ass iwl3945 driver drops packets with
 WEP  enabled
Message-Id: <20080820175054.0795eecb.akpm@linux-foundation.org>
In-Reply-To: <1749.69.2.248.210.1219253222.squirrel@webmail.wolfmountaingroup.com>
References: <1749.69.2.248.210.1219253222.squirrel@webmail.wolfmountaingroup.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 11:27:02 -0600 (MDT)
jmerkey@wolfmountaingroup.com wrote:

> 
> On an Acer 9410 laptop with dual core processors, the iwl3945 driver has
> intermittment receiver lockup problems (stops receiving packets) using the
> Linux iwl3945 drivers with WEP encryption enbaled.  The adapter works fine
> without WEP or WPA.   If the same system is booted to Windows Vista (which
> takes about 15 minutes to boot because Vista is a fat slow pig) the
> wireless drivers work fine with WEP under Vista on the same system.
> 
> If the system copies the ndis .sys drivers and I build ndiswrapper (which
> has to be really hacked up to build on 2.6.27) and use the ndis drivers on
> 2.6.27-rc3 with a modified ndiswrapper, they work fine.
> 
> I suspect the firmware or an interaction with the firmware settings since
> when the system is booted to Vista after running 2.6.27-rc3 with the
> iwl3945 drivers, I have to power cycle the system periodically after
> running the iwl3945 driver to get the drivers under Vista to work again,
> but not always.
> 

(cc linux-wireless)

Was 2.6.26 OK?
