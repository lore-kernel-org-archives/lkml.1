Return-Path: <linux-kernel-owner+w=401wt.eu-S933625AbXFGQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbXFGQPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932673AbXFGQPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:15:36 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbXFGQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:15:35 -0400
Message-ID: <46682EFA.1020406@zytor.com>
Date: Thu, 07 Jun 2007 09:14:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
References: <20070606225837.654272428@goop.org> <200706062147.21225.rob@landley.net> <46676552.4060308@zytor.com> <200706071208.04777.rob@landley.net>
In-Reply-To: <200706071208.04777.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> Er, make that objcopy, not objdump.
> 
> Sane, maybe not.  Something people want to do (and under the mistaken 
> assumption I know more about initramfs then they do, have asked me how), yes.  
> It always boils down to "do you have a vmlinux image lying around?  Doing 
> this with a bzImage _is_ brain surgery", and has yet to get beyond that 
> question.  I had about half of a script worked out for this, once...
> 

If it can be done today on a vmlinux then it can be done the same way
with the mechanism I have proposed.  Period, full stop.

> You can also supply an external initramfs image through the initrd mechanism, 
> but this is unpleasant to do with some bootloaders (or lack of bootloaders).  
> Plus it doesn't remove the old one, and wasting space makes embedded 
> developers itch.

In thory one could create an extended bzImage format which could handle
a concatenated, and easily replaceable, initrd, but if it's done on
vmlinux today it would make a *lot* more sense to have it be done on the
vmlinux and nothing else.

	-hpa
