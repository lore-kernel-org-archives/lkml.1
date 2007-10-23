Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbXJWJNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbXJWJNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXJWJNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:13:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54806 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbXJWJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:13:37 -0400
Date: Tue, 23 Oct 2007 11:13:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Morris <jmorris@namei.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
Message-ID: <Pine.LNX.4.64.0710231110560.16684@fbirervta.pbzchgretzou.qr>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 21 2007 08:57, James Morris wrote:
>> >I'd like to note that I asked people who were actually affected, and had 
>> >examples of their real-world use to step forward and explain their use, 
>> >and that I explicitly mentioned that this is something we can easily 
>> >re-visit.
[...]

I looked at commit 20510f2f4e2dabb0ff6c13901807627ec9452f98
[havenot done much kernel activity recently] where you
transform the security interface, and what I see is that
all the static inline functions are replaced by an extern one, with the
same content. That actually seems to include more performance hit
than the (un)registering fluff. Why is that, actually?
