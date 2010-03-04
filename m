Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0CDBQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:16:51 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:49423 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887Ab0CDBQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:16:37 -0500
Message-ID: <4B8F0A42.5070405@lougher.demon.co.uk>
Date: Thu, 04 Mar 2010 01:17:54 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Alain Knaff <alain@knaff.lu>
Subject: Re: [GIT PULL] Squashfs updates for 2.6.34
References: <4B8C1873.1080700@lougher.demon.co.uk> <alpine.LFD.2.00.1003030904040.3627@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003030904040.3627@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> 
> Please. Don't add more ugly generic header files into the main include 
> directory. I realize that the ugliness is partly historical (that 
> "<linux/decompress/mm.h>" file sure as hell was messy to begin with), but 
> this just makes that crazy situation worse.
> 
> Clean up the mess instead of making it even less understandable. Please. 
> That whole "#ifdef STATIC" crap needs to go - not get spread out even 
> more.
> 

OK.  The decompressor code (inflate/bunzip/lzma) is a "pile
of crap" and mm.h more so.  In the past six months I've fixed a lot
of truly bad problems with that code (NULL pointers, buffer over-runs etc.).

In my defence with these patches I was trying for the best solution while
touching as little of the mess as possible.  As that's not acceptable, I'll
go away and try and fix some of the mess, before trying for another merge.

Thanks

Phillip

