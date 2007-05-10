Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbXEJU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbXEJU6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXEJU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:58:11 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429AbXEJU6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:58:09 -0400
Date: Thu, 10 May 2007 13:56:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22 - part 2
In-Reply-To: <alpine.LFD.0.98.0705101330320.3986@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705101353370.3986@woody.linux-foundation.org>
References: <200705100411.32349.lenb@kernel.org>
 <alpine.LFD.0.98.0705101330320.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 May 2007, Linus Torvalds wrote:
> 
> Seems to work for me. My evo correctly started the fan, and stopped it 
> when the temperature went down again.

Looking at things in "top", I do end up occasionally seeing spikes where 
kacpid takes 17% of CPU time, and kacpi_notify takes a few percent too. 
But the machine works ok, and it doesn't seem to be horrible:

   64 ?        S<     0:15 [kacpid]
   65 ?        S<     0:08 [kacpi_notify]

so they've gotten 23 seconds of CPU time over the 37 minutes that laptop 
has been up now. That's arguably too much, but on the other hand, I did 
end up trying to stress it out by doing some 3D stuff while compiling the 
kernel and doing "git grep" over the kernel tree etc.

			Linus
