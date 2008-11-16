Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYKPBzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYKPBzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 20:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYKPBzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 20:55:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYKPBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 20:55:39 -0500
Message-ID: <491F7D88.7080403@zytor.com>
Date: Sat, 15 Nov 2008 17:55:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Philipp Kohlbecher <xt28@gmx.de>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: alternative identifier for Phoenix BIOS
References: <491EEDE8.5080508@gmx.de>
In-Reply-To: <491EEDE8.5080508@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Kohlbecher wrote:
> My laptop (a Samsung X20) contains a Phoenix BIOS and would benefit from
> patch 1e22436eba84edfec9c25e5a25d09062c4f91ca9 (x86: reserve low 64K on
> AMI and Phoenix BIOS boxen).
> 
> However, according to /sys/class/dmi/id/bios_vendor, the BIOS identifies
> its vendor as "Phoenix Technologies LTD" (sans the comma).

Given that AMI and Phoenix combined is something like 80% of the BIOS
market, if not more, it might simply be easier to make it unconditional,
 or make it a whitelist instead.

	-hpa
