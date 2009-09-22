Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZIVR22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZIVR22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZIVR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:28:27 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:57608 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZIVR21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:28:27 -0400
Date: Tue, 22 Sep 2009 19:28:19 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Brian McGrew <brian@visionpro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: (un)mount ramfs from C code
Message-ID: <20090922172819.GA27978@citd.de>
References: <C6DE438F.127DA%brian@visionpro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6DE438F.127DA%brian@visionpro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.09.2009 09:04, Brian McGrew wrote:
> Good morning all!
> 
> So I'm using a ramfs for temporary files, thank you whoever designed that,
> it works great!
> 
> I can mkdir, mount, chmoud, readand write and then umount the thing from the
> command line just fine.
> 
> What I need now is some method from within my C/C++ code to determine if the
> ramfs is mounted, if not, then mount it so I can use it and unmount it when
> I'm done, without making a system call.
> 
> Can this be done?  Is there any access to mount/unmount from C/C++?

The "/bin/mountpoint"-util appears to stat the mountpoint and it's 
parent directory and compares if they have the same device-no (st_dev). 
If they are different, then something is mounted.






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

