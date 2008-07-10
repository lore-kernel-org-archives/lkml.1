Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYGJTFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYGJTFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761408AbYGJTFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:05:21 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55254 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760753AbYGJTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:05:19 -0400
Date: Thu, 10 Jul 2008 21:05:08 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Marcus Sundberg <marcus@ingate.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26-rc9] r8169: Avoid thrashing PCI conf space on
	RTL_GIGA_MAC_VER_20.
Message-ID: <20080710190508.GA18477@electric-eye.fr.zoreil.com>
References: <48760F22.8040208@ingate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48760F22.8040208@ingate.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Sundberg <marcus@ingate.com> :
> The magic write to register 0x82 will often cause PCI config space on
> my 8168 (PCI ID 10ec:8168, revision 2. mounted in an LG P300 laptop)
> to be filled with ones during driver load, and thus breaking NIC
> operation until reboot. If it does not happen on first driver load it
> can easily be reproduced by unloading and loading the driver a few
> times.

Nice. Thanks.

[...]
> ---
> The magic write is not present in the r8168 driver from RealTek either.
> Does anyone know what it's supposed to do?

No idea. It is not used in the 8101/8102 driver either.

-- 
Ueimor
