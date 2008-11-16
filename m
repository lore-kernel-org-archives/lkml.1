Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKPUge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKPUge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 15:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYKPUgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 15:36:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbYKPUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 15:36:23 -0500
Message-ID: <4920836E.1080803@kernel.org>
Date: Sun, 16 Nov 2008 12:32:46 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
References: <1226846868-9595-1-git-send-email-bwalle@suse.de> <20081116073948.02aea58c@infradead.org>
In-Reply-To: <20081116073948.02aea58c@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> I assume /dev/crash is read only
> 
> but your series still makes absolutely no sense to me...
> really. Nak.
> 
> You either want this at compile time or you don't want it at all.
> 

You could certainly envision this as a boottime option, or even a
*one-way* settable runtime option (kind of like the BSD securelevel
idea.)  The question is to which extent even that makes any sense.

	-hpa
