Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYBPLuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYBPLuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYBPLu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:50:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:43086 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbYBPLu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:50:27 -0500
Subject: Re: [PATCH 1/2] fb: add support for foreign endianness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20080205154432.GA8749@localhost.localdomain>
References: <20080205154432.GA8749@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 22:49:58 +1100
Message-Id: <1203162598.22915.48.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 18:44 +0300, Anton Vorontsov wrote:
> This patch adds support for the framebuffers with non-native
> endianness. This is done via FBINFO_FOREIGN_ENDIAN flag that will
> be used by the drivers. Depending on the host endianness this flag
> will be overwritten by FBINFO_BE_MATH internal flag, or cleared.
> 
> Tested to work on MPC8360E-RDK (BE) + Fujitsu MINT framebuffer (LE).

Good luck running X on that thing :-)

The base server seems to cope.. until you start using render operations
or that sort of things, and then things blow up. There's shitload of
stuff that seems to assume native fb endianness..

Ben.


