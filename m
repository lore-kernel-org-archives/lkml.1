Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0BQTjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 14:39:48 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38772 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0BQTjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 14:39:47 -0500
Message-ID: <4B7C45E8.80402@cs.helsinki.fi>
Date: Wed, 17 Feb 2010 21:39:20 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: [PATCH] kmemcheck: Test the full object in	kmemcheck_is_obj_initialized()
References: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> This is a fix for bug #14845 (bugzilla.kernel.org). The
> update_checksum() function in mm/kmemleak.c calls
> kmemcheck_is_obj_initialised() before scanning an object. When
> KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
> the crc32_le() reads smaller intervals (32-bit) for which
> kmemleak_is_obj_initialised() may be false leading to a kmemcheck
> warning.
> 
> Note that kmemcheck_is_obj_initialized() is currently only used by
> kmemleak before scanning a memory location.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christian Casteyde <casteyde.christian@free.fr>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Vegard Nossum <vegardno@ifi.uio.no>

Applied to slab.git.
