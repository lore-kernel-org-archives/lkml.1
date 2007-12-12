Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbXLLXDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbXLLXDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXLLXDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:03:40 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46237 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbXLLXDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:03:39 -0500
Date: Wed, 12 Dec 2007 23:56:30 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/sis190.c section fix
Message-ID: <20071212225630.GA15947@electric-eye.fr.zoreil.com>
References: <20071211222356.GA14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211222356.GA14204@stusta.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> :
> This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:
[...]
> WARNING: vmlinux.o(.init.text.20+0x4cb25): Section mismatch: reference to .exit.text:sis190_mii_remove (between 'sis190_init_one' and 'read_eeprom')

Thanks. Applied at:

git://git.kernel.org/pub/scm/linux/kernel/git/romieu/netdev-2.6.git sis190

-- 
Ueimor
