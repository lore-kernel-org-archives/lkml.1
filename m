Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbXGDF3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbXGDF3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 01:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXGDF3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 01:29:06 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34598 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXGDF3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 01:29:05 -0400
Message-ID: <468B301D.7010807@vmware.com>
Date: Tue, 03 Jul 2007 22:29:01 -0700
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Matt Sealey <matt@genesi-usa.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fusion MPT regression, fixed or not?
References: <4689F886.6070000@genesi-usa.com>
In-Reply-To: <4689F886.6070000@genesi-usa.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Sealey wrote:
> Hello World,
> 
> I re-stumbled on this installing Gentoo on VMware today;
> 
> http://lkml.org/lkml/2007/3/23/312
> 
> It doesn't seem to be fixed in 2.6.22-rc7, but I might be mistaken
> somehow. Has anyone done any work on this or looked at the problem
> in more detail? The trail seems to die at that thread.

Not that it is relevant to LKML, but you need either upgrade to VMware 
Workstation 6.0, or you need patch later in that thread: 
http://lkml.org/lkml/2007/3/23/345

> It is affecting VMware for me mainly but a lot of heavy server
> hardware seems to use the chip, in fact some I am looking at right
> now to recommend purchasing on.. I'd really like to use the latest
> kernel because virtualisation is the key (dynamic ticks and
> tickless hz and the latest virtualisation options would help eke out
> more value ;)

It affects only VMware's emulation, not real hardware (at least unless 
you hit one with broken firmware).
							Petr
