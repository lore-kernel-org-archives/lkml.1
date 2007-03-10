Return-Path: <linux-kernel-owner+w=401wt.eu-S1767723AbXCJCLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767723AbXCJCLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 21:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767725AbXCJCLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 21:11:04 -0500
Received: from smtpout.mac.com ([17.250.248.173]:65079 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767723AbXCJCLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 21:11:03 -0500
In-Reply-To: <20070310014230.GP10394@waste.org>
References: <20070309053931.GA10459@waste.org> <200703101134.26313.kernel@kolivas.org> <20070310004948.GN10394@waste.org> <200703101228.38923.kernel@kolivas.org> <20070310014230.GP10394@waste.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <05EF05C7-0E33-4B52-B54D-AF7713EE5195@mac.com>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Fri, 9 Mar 2007 21:10:01 -0500
To: Matt Mackall <mpm@selenic.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 09, 2007, at 20:42:30, Matt Mackall wrote:
> Doh, can't believe I didn't notice that. That's apparently a  
> default in Debian/unstable (not sure where to tweak it).

Run this:
root@localhost:~# dpkg-reconfigure xserver-xorg

It should ask you if you want to run the X-server at a lower  
(higher?) nice level.

To decrease the minimum-debconf-priority for new package  
installations you can run this:

root@localhost:~# dpkg-reconfigure debconf

Change the "Ignore questions with a priority less than: " value to  
"medium" or "low".

Cheers,
Kyle Moffett
