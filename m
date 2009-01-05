Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZAEBdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZAEBdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZAEBdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:33:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZAEBdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:33:01 -0500
Date: Mon, 5 Jan 2009 02:46:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] Only scan the root bus in early PCI quirks.
Message-ID: <20090105014645.GD496@one.firstfloor.org>
References: <200901051236.281008835@firstfloor.org> <20090104233638.60AF53E6653@basil.firstfloor.org> <86802c440901041551y321329e1l9c40186fc381f355@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440901041551y321329e1l9c40186fc381f355@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> two cases:
> 1. how about system with two or more HT chains, and second will be
> 0x40, x0x80, or 0xc0 ?

The early quirks code only cares about the first south bridge,
it's essentially just a chipset detect. So secondaries do not 
matter. 

> 2. some system with LinuxBIOS, could put first chain on bus 1

Do they or do they not? Please be specific. 

Anyways AntiLinuxBIOS doesn't have ACPI and early-quirks.c is 80%+ ACPI
workarounds so they don't apply. The only exceptions are the VIA
detect or the the HT broadcast workaround. I suppose both do not
apply to these LB systems.

-Andi
-- 
ak@linux.intel.com
