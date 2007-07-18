Return-Path: <linux-kernel-owner+w=401wt.eu-S936170AbXGRSro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936170AbXGRSro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXGRSrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:47:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44696 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495AbXGRSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:47:35 -0400
Date: Wed, 18 Jul 2007 20:47:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718184734.GE3898@one.firstfloor.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718182021.GA3898@one.firstfloor.org> <Pine.LNX.4.64.0707182024231.5385@fbirervta.pbzchgretzou.qr> <20070718183840.GC3898@one.firstfloor.org> <Pine.LNX.4.64.0707182042580.5385@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707182042580.5385@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And the hypothetical case where RAM is hotplugged and/or recognized after the
> kernel has been loaded by the bootloader? I do not claim to be an expert, but

RAM hotadd needs working user space to trigger it.

Besides it typically comes with cpuhotplug too, so you couldn't even
discard __cpuinit.

-Andi (who is out of the thread because it's getting silly) 
