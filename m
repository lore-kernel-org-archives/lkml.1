Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXIWSbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXIWSbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXIWSbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:31:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:31736 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXIWSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JgRJsLrxqA4ukqxnVDjPTPZ/K0v3qk4G9J5jE5XdNLo2CUp+QUgKrLJBindeL3ZhhiziL0BrlD6LQqcevT8NbqrbstBUzzJLBtJAC8Cs+M/XpY+tASRGo4AfXbYJcp5Co+gwrk3FcHfmymU3XOuajS4/j081StPe8QdeFuUnSqA=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Date: Sun, 23 Sep 2007 21:31:02 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709220828.00078.mihai.dontu@gmail.com> <200709231937.13595.mihai.dontu@gmail.com> <200709232051.39949.mihai.dontu@gmail.com>
In-Reply-To: <200709232051.39949.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709232131.02348.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2007, Mihai Donțu wrote:
> I'll to do a full cleanup and start all over. I'm going to nail this thing down if
> it's the last thing I do! (so help me God) :)

  Found it!

  The problem was "Framebuffer Console support". It was enabled by default in older
  configs (like 2.6.22.7) but I think someone noticed this was bad and put it to
  default N in newer (2.6.23-rc7); and since I reused the .config from 2.6.21.3 ...

  So there, if one wants "ATI Radeon display support" on Radeon XPRESS 200M with
  X using radeon_drv.so, *should* put "Framebuffer Console support" to N (if it's
  not already).

  Now all I have to do is figure out what's the equivalent of "vga=791" on the new
  kernel (default text console looks really bad on my laptop).

  Sorry for all the noise (and spam),

-- 
Mihai Donțu
