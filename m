Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbXH3Vzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbXH3Vzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbXH3Vzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:55:42 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34241 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbXH3Vzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:55:41 -0400
Date: Thu, 30 Aug 2007 23:55:37 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Clemens Kolbitsch <clemens.kol@gmx.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: Forbid deletion of memory mappings
In-Reply-To: <200708302341.09459.clemens.kol@gmx.at>
Message-ID: <Pine.LNX.4.64.0708302354240.2460@twin.jikos.cz>
References: <200708301844.10532.clemens.kol@gmx.at> <200708302332.42744.clemens.kol@gmx.at>
 <Pine.LNX.4.64.0708302333320.2460@twin.jikos.cz> <200708302341.09459.clemens.kol@gmx.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:

> the thing is that they are not. the kernel chooses to REPLACE my 
> mapping.
> consider the user-space code:
> mmap(0xaaaa0000, 0x3000, MAP_FIXED, ...);
> mmap(0xaaaa1000, 0x4000, MAP_FIXED, ...);
> here, the second call to mmap will shorten the first mapping to 0x1000 bytes 
> and create one big vma with size 0x5000 bytes.

Which is exactly in compliance with what POSIX says about MAP_FIXED mmaps 
- see http://opengroup.org/onlinepubs/007908799/xsh/mmap.html

-- 
Jiri Kosina
