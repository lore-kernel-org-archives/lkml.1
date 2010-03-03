Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0CCPTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:19:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38201
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327Ab0CCPTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:19:48 -0500
Date: Wed, 03 Mar 2010 07:20:07 -0800 (PST)
Message-Id: <20100303.072007.170106625.davem@davemloft.net>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] X doesn't work with 2.6.33 (can't find any input
 devices)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100303151720.GA3191@thunk.org>
References: <20100303151720.GA3191@thunk.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tytso@mit.edu
Date: Wed, 3 Mar 2010 10:17:20 -0500

> It worked just *fine* using 2.6.33-rc4.  I have no xorg.conf file (X
> is autoconfiguring itself) and I'm using an Ubuntu 9.10 userspace.

X uses udev events to find input devices these days, so it's probably
the same problem preventing your lvm devices from showing up correctly
from initramfs.
