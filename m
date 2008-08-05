Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbYHERjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbYHERjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762645AbYHERi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:38:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:45853 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762564AbYHERi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:38:56 -0400
Date: Tue, 5 Aug 2008 10:38:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805103840.1aaa64a5@infradead.org>
In-Reply-To: <1217956796.11547.12.camel@paris.rdu.redhat.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008 13:19:56 -0400
Eric Paris <eparis@redhat.com> wrote:

> If you can outline the design of a better method that meets your needs
> I'd be glad to try to code it.  In your mind how do you see programs
> being able to exclude others while not being a security risk? 


ok so lets be specific.
You are trying to prevent an application from opening a "damaged" file,
or from someone starting a "damaged" file.
You are not trying to prevent anything once you have executed a damaged
file; once you execute one of these for this part it's game over (to
limit the damage other tools like selinux exist, but are outside the
scope of talpa).

So... as long as /sbin/init isn't compromised... intercepting exec and
open (in all variants) is all you need.

And this can be done from userland with the preload: the "workaround"
from the preload assumes you've already executed malicious code, which
is outside of your protection scope.

What am I missing?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
