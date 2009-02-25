Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbZBYL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbZBYL5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbZBYL5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:57:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54817
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755616AbZBYL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:57:31 -0500
Date: Wed, 25 Feb 2009 03:57:12 -0800 (PST)
Message-Id: <20090225.035712.103590506.davem@davemloft.net>
To: jon@nerdgrounds.com
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: ATI Radeon DIRECTCOLOR -> TRUECOLOR patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <49A52A73.2000406@nerdgrounds.com>
References: <49A52A73.2000406@nerdgrounds.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Campbell <jon@nerdgrounds.com>
Date: Wed, 25 Feb 2009 03:24:35 -0800

[ Ben H. is the Radeon driver maintainer, as listed in
  linux/MAINTAINERS, you might want to CC: him ]

> I don't know about you but when I ask the framebuffer to set up
> 16-bit or 32-bit RGB modes I expect a video mode to be set up with
> R, G, and B mapped linearly so that I can display images properly,
> not some odd "directcolor" mode that seems to serve no other purpose
> than to avoid a few shifts converting the fbcon palette to an RGB
> triplet.

It might be using DIRECTCOLOR for compatibility with openfirmware,
BOOTX, or similar on PowerPC.

Ben?
