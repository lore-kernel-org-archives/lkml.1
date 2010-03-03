Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0CCRJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:09:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456Ab0CCRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:09:16 -0500
Date: Wed, 3 Mar 2010 09:08:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Alain Knaff <alain@knaff.lu>
Subject: Re: [GIT PULL] Squashfs updates for 2.6.34
In-Reply-To: <4B8C1873.1080700@lougher.demon.co.uk>
Message-ID: <alpine.LFD.2.00.1003030904040.3627@localhost.localdomain>
References: <4B8C1873.1080700@lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Mar 2010, Phillip Lougher wrote:

> 
> Please pull the following Squashfs updates.  They add support
> for lzma compressed file systems, plus there's also a couple of
> trivial code tidy patches.

No. I'm not pulling this. 

>  include/linux/decompress/bunzip2_mm.h |   13 +++
>  include/linux/decompress/inflate_mm.h |   13 +++
>  include/linux/decompress/mm.h         |    4 -
>  include/linux/decompress/unlzma_mm.h  |   20 +++++
>  include/linux/decompress/unlzo_mm.h   |   13 +++

What the _h*ll_ is the point of these totally illogical and ugly files? 
The name makes no sense, and the _contents_ make zero sense either.

Please. Don't add more ugly generic header files into the main include 
directory. I realize that the ugliness is partly historical (that 
"<linux/decompress/mm.h>" file sure as hell was messy to begin with), but 
this just makes that crazy situation worse.

Clean up the mess instead of making it even less understandable. Please. 
That whole "#ifdef STATIC" crap needs to go - not get spread out even 
more.

		Linus
