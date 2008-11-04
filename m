Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYKDVMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYKDVMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYKDVMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:12:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040AbYKDVMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:12:38 -0500
Date: Tue, 4 Nov 2008 13:12:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
In-Reply-To: <20081104203036.GE5862@ucw.cz>
Message-ID: <alpine.LFD.2.00.0811041307030.3419@nehalem.linux-foundation.org>
References: <20081104062734.GA4420@havoc.gtf.org> <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org> <20081104203036.GE5862@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Nov 2008, Pavel Machek wrote:
>
> (Is park command normally supported on modern disks? IIRC hdaps people
> had issues with not all disks supporting it?)

The modern version of parking is called "idle immediate". It may be that 
only laptop drives support the "unload" part. But it's definitely not an 
ancient and deprecated thing (although calling it "parking" is apparently 
old-fashioned :)

			Linus
