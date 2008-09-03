Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYICPy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYICPy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYICPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:54:48 -0400
Received: from vena.lwn.net ([206.168.112.25]:32932 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYICPys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:54:48 -0400
Date: Wed, 3 Sep 2008 09:54:46 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, devel@laptop.org
Subject: Re: [PATCH 3/3] Define and use PCI_DEVICE_ID_MARVELL_88ALP01_CCIC
 for =?ISO-8859-1?B?Q0FGyQ==?= camera driver
Message-ID: <20080903095446.330c70d1@bike.lwn.net>
In-Reply-To: <1220438902.2985.101.camel@pmac.infradead.org>
References: <1220438625.patch@pmac.infradead.org>
	<1220438902.2985.101.camel@pmac.infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2008 11:48:22 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> Also, stop looking at the NAND controller (0x4100) and checking the
> device class. For a while during development, all three functions on
> the chip had the same ID. We made them fix that fairly promptly, and
> we can forget about it now.

I see no harm in having the driver check the device to ensure it's what
it thinks it is - we can probably afford the runtime overhead.  But
whatever, I'm not that concerned; toss in an

	Acked-by: Jonathan Corbet <corbet@lwn.net>

if you wish.

jon
