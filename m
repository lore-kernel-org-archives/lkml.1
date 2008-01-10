Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbYAJTU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbYAJTU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYAJTUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:20:51 -0500
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:58204 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYAJTUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:20:50 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Nathan Grennan <alistair@cygnusx-1.org>
Subject: Re: r8169 and out of space
Date: Thu, 10 Jan 2008 19:20:46 +0000
User-Agent: KMail/1.9.7
References: <478655B6.6010406@cygnusx-1.org>
In-Reply-To: <478655B6.6010406@cygnusx-1.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101920.47041.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla for this report: http://bugzilla.kernel.org/show_bug.cgi?id=9468

On Thursday 10 January 2008 17:28:22 you wrote:
>   I saw your thread on LKML about the problem with r8169. Did you ever
> find a patch or solution?

No, we have not diagnosed the cause of the problem, beyond the swiotlb usage. 
I'm adding the r8169 maintainer, linux-net and linux-kernel to CC, to pass on 
your information, I hope you don't mind.

>   I have a Abit AB9 Pro motherboard with Intel P965 chipset, 4gb of
> memory, and two onboard r8169. The kernel is
> kernel-2.6.23.9-85.fc8.x86_64. I am using jumbo frames, the MTU set at
> 5924. The error is mentions 5946 bytes. 5946 - 5924 is 22. The same as
> your 7200 MTU subtracted from your bytes, 7222.
>
>   I can set my MTU to 7200, and I can ping with 60000 byte packets just
> fine, but tcp connections hang unless I set the MTU to 5924 or lower.
> The other side is a Nvidia based board with a forcedeth driver that has
> in the past taken 9000 just fine.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
