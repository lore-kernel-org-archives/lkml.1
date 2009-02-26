Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZBZUds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZBZUds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZBZUdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:33:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537AbZBZUdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:33:36 -0500
Date: Thu, 26 Feb 2009 12:33:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49A6F39F.9040801@krogh.cc>
Message-ID: <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain> <49A6F39F.9040801@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Jesper Krogh wrote:
> 
> 2.6.26.8 doesnt have this problem.
> 
> The "current_clocsource" is the same on both systems.
> 
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc

What does the frequency calibrate to? It should be in the dmesg. Does it 
differ by a big amount?

		Linus
