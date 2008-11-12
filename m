Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYKLXyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYKLXyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYKLXy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:54:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYKLXy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:54:28 -0500
Message-ID: <491B681B.6040405@kernel.org>
Date: Wed, 12 Nov 2008 15:34:51 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Always use 64 bit addresses for the firmware memory map
References: <1226519089-21647-1-git-send-email-bwalle@suse.de> <491B398C.9090207@goop.org>
In-Reply-To: <491B398C.9090207@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> resource_size_t should always be 64-bit on PAE now.
> 

Yes, but this would affect non-PAE kernels too.

	-hpa
