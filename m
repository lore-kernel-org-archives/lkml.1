Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZDSEJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZDSEJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbZDSEJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:09:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbZDSEJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:09:36 -0400
Date: Sat, 18 Apr 2009 21:09:27 -0700 (PDT)
Message-Id: <20090418.210927.229687293.davem@davemloft.net>
To: dave@thedillows.org
Cc: brice@myri.com, sgruszka@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH net-next] myri10ge: allow per-board firmware overriding
From: David Miller <davem@davemloft.net>
In-Reply-To: <1240102617.5342.6.camel@obelisk.thedillows.org>
References: <20090417095038.49b745bf@dhcp-lab-109.englab.brq.redhat.com>
	<49EA1DAC.1000602@myri.com>
	<1240102617.5342.6.camel@obelisk.thedillows.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Dillow <dave@thedillows.org>
Date: Sat, 18 Apr 2009 20:56:57 -0400

> It seems like this could be done in user space, using the PCI bus ID as
> a key to select the firmware.

PCI BUS ID's are not in any way unique, you would need to include the
PCI Domain as well.
