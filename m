Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbXKDRqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbXKDRqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 12:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXKDRqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 12:46:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbXKDRqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 12:46:04 -0500
Date: Sun, 4 Nov 2007 09:45:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
cc: Andrew Haley <aph@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tomash Brechko <tomash.brechko@gmail.com>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <e2e108260711040713g2802b262sda75672f8e0f50f6@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0711040943540.15101@woody.linux-foundation.org>
References: <18210.2314.57767.962503@zebedee.pink> 
 <MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>  <18215.1394.294830.944162@zebedee.pink>
  <e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com> 
 <18219.17505.443550.620503@zebedee.pink>
 <e2e108260711040713g2802b262sda75672f8e0f50f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, Bart Van Assche wrote:
> 
> Has it already been decided who will do this audit, and when this
> audit will happen ? Has a target date been set when this audit should
> be complete, or is the completion of this audit a requirement for the
> release of a specific gcc version ?

I am told that the gcc people realized that was indeed a bug (people were 
able to show problems even in non-threaded environments with mprotect()), 
and have now fixed it in the current gcc sources. That still leaves the 
old versions with potential problems, but I think it makes it much less 
interesting to audit for these things.

		Linus
