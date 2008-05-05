Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYEEEzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYEEEzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYEEEzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:55:10 -0400
Received: from ozlabs.org ([203.10.76.45]:32975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbYEEEzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:55:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: changeset: Make forced module loading optional
Date: Mon, 5 May 2008 14:55:02 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051455.02723.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus's recent commit said:
> The kernel module loader used to be much too happy to allow loading of
> modules for the wrong kernel version by default. For example, if you
> had MODVERSIONS enabled, but tried to load a module with no version
> info, it would happily load it and taint the kernel - whether it was
> likely to actually work or not!
...
> Especially as it happened to me by mistake (ie regular unversioned Fedora
> modules getting loaded) causing lots of strange behavior.

Hi Linus,

   I'm trying to figure out how you did this.  So fedora builds unversioned 
modules, and version (and vermagic) matched your kernel?  And you somehow 
mixed them up?

   I don't think relying on modversions is the complete answer here.  Perhaps 
we should make modules_install blow away old modules?

Cheers,
Rusty.
