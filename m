Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYK0XfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYK0XfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 18:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYK0Xe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 18:34:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36129
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYK0Xez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 18:34:55 -0500
Date: Thu, 27 Nov 2008 15:34:55 -0800 (PST)
Message-Id: <20081127.153455.198106378.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: jeffrey.t.kirsher@intel.com, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, netdev@vger.kernel.org
Subject: Re: [PATCH 14/32] ixgbe section fixes (against netdev)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081127232335.GF28946@ZenIV.linux.org.uk>
References: <E1L3wOM-0006Ti-Jt@ZenIV.linux.org.uk>
	<9929d2390811221143n66f3f09bu3801919a54263589@mail.gmail.com>
	<20081127232335.GF28946@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 27 Nov 2008 23:23:35 +0000

> ixgbe_init_interrupt_scheme() is called from ixgbe_resume().  Build that
> with CONFIG_PM and without CONFIG_HOTPLUG and you've got a problem.
> Several helpers called by it also are misannotated __devinit.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.
