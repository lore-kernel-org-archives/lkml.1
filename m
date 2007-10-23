Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXJWHMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXJWHMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXJWHMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:12:43 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:55673 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752081AbXJWHMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:12:42 -0400
Message-ID: <471D9ECB.6060400@crispincowan.com>
Date: Tue, 23 Oct 2007 00:12:11 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Giacomo Catenazzi <cate@debian.org>
CC: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: LSM conversion to static interface
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com> <471D8C54.4050907@debian.org>
In-Reply-To: <471D8C54.4050907@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giacomo Catenazzi wrote:
> What do technical and regulatory differences have "driver/LSM module" that
> is build-in and one that is modular?
> It seems to me silly to find difference.  A kernel with a new kernel module
> is a new kernel.
>   
*I* understand that, from a security and logic integrity point of view,
there is not much difference between a rebuilt-from-source kernel, and a
standard kernel from the distro with a new module loaded.

However, there is a big difference for other people, depending on their
circumstances.

    * Some people live in organizations where the stock kernel is
      required, even if you are allowed to load modules. That may not
      make sense to you, but that doesn't change the rule.
    * Some people are not comfortable building kernels from source. It
      doesn't matter how easy *you* think it is, it is a significant
      barrier to entry for a lot of people. Especially if their day job
      is systems or security administration, and not kernel hacking.

Think of it like device drivers: Linux would be an enterprise failure if
you had to re-compile the kernel from source every time you added a new
kind of device and device driver.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
	       Itanium. Vista. GPLv3. Complexity at work

