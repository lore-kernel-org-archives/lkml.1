Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbZDQRbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbZDQRbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbZDQRbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:31:45 -0400
Received: from vena.lwn.net ([206.168.112.25]:35809 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbZDQRbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:31:44 -0400
Date: Fri, 17 Apr 2009 11:31:42 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
 syscalls with a mutex
Message-ID: <20090417113142.3151579b@bike.lwn.net>
In-Reply-To: <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain>
References: <1239892078-6039-1-git-send-email-abogani@texware.it>
	<20090416160645.GB17804@elte.hu>
	<20090416235649.GF26366@ZenIV.linux.org.uk>
	<20090417000142.GF21405@elte.hu>
	<20090417001345.GH26366@ZenIV.linux.org.uk>
	<20090417002744.GB29630@elte.hu>
	<20090417003805.GI26366@ZenIV.linux.org.uk>
	<20090417165643.GL8253@elte.hu>
	<1239987885.23397.4817.camel@laptop>
	<alpine.LFD.2.00.0904171010470.4042@localhost.localdomain>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 10:21:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And I know we had patches for file locking BKL-removal at some point. What 
> happened to them? Were they just broken, or forgotten, or waiting in Jon's 
> tree, or what?

Not in my tree, I've not seen them.  I could maybe take a look at that,
I've just about recovered from my fasync experience...:)

jon
