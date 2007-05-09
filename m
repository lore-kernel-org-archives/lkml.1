Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbXEIKWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbXEIKWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbXEIKWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:22:23 -0400
Received: from twin.jikos.cz ([213.151.79.26]:44585 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbXEIKWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:22:22 -0400
Date: Wed, 9 May 2007 12:22:14 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21] kernel panic
In-Reply-To: <Pine.LNX.4.64.0705070029580.16923@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0705091221360.16923@twin.jikos.cz>
References: <20070506115651.GA13183@vanheusden.com>
 <Pine.LNX.4.64.0705061632500.16923@twin.jikos.cz> <20070506164944.GA15682@vanheusden.com>
 <Pine.LNX.4.64.0705070029580.16923@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Jiri Kosina wrote:

> OK, I think the patch below should solve this. I am pretty surprised 
> though that this bug wasn't triggered/reported by anyone anytime sooner, 
> it has been there for ages too (but ok, the race window should be pretty 
> small and hiddev is usually not high-throughput interface).
> Could you please test it and let me know?
> From: Jiri Kosina <jkosina@suse.cz>
> USB HID: hiddev - fix race between hiddev_send_event() and hiddev_release()

Flokert,

did you have time to verify whether this patch fixes the issue for you?

Thanks,

-- 
Jiri Kosina
