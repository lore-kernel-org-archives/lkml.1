Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYKLXmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYKLXmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbYKLXjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:39:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbYKLXjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:39:09 -0500
Message-ID: <491B6855.1080609@kernel.org>
Date: Wed, 12 Nov 2008 15:35:49 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bernhard Walle <bwalle@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] Always use 64 bit addresses for the firmware memory map
References: <1226519089-21647-1-git-send-email-bwalle@suse.de>	<491B358D.2040304@kernel.org> <20081112221106.5d9d7801@kopernikus.site>
In-Reply-To: <20081112221106.5d9d7801@kopernikus.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * H. Peter Anvin [2008-11-12 11:59]:
>> I want to make sure, though, that we don't just end up pushing the
>> truncation further down in the code.
> 
> Well, I think that interface should export the BIOS memmap as provided.
> Since E820 does provide 64 bit addresses, that should get exported.
> 
> It should even possible to kexec a PAE kernel from a non PAE kernel ...
> I didn't test, but it could work. But only if the E820 map is correctly
> written in the zero page, which is only the case if we get it correctly.
> 

That's fine, but we do have to check that we don't truncate elsewhere.

	-hpa
