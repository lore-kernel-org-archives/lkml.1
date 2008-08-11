Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYHKVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYHKVu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYHKVur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:50:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57223
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbYHKVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:50:46 -0400
Date: Mon, 11 Aug 2008 14:50:47 -0700 (PDT)
Message-Id: <20080811.145047.105665450.davem@davemloft.net>
To: cl@linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A0B037.501@linux-foundation.org>
References: <48A086B6.2000901@linux-foundation.org>
	<20080811.141501.01468546.davem@davemloft.net>
	<48A0B037.501@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>
Date: Mon, 11 Aug 2008 16:33:43 -0500

> Maybe what we are seeing is general bloat in kernel execution paths
> due to the growth in complexity?

It could be, and any kind of analysis into this would be great.

I had a change that RCU destroyed sockets and this added a
tiny bit of latency, so I never added it even though it would
have allowed a lot of simplification of socket handling (which
I though would make up for RCU's latency, but it didn't).
