Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXFMQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXFMQhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbXFMQhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:37:35 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51978 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744AbXFMQhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:37:34 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: Dave Hansen <hansendc@us.ibm.com>
To: holzheu@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
In-Reply-To: <1181747217.29512.9.camel@localhost.localdomain>
References: <1181747217.29512.9.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 09:37:29 -0700
Message-Id: <1181752649.15815.68.camel@spirit>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 17:06 +0200, holzheu wrote:
> The operation of a Linux system sometimes requires to decode the
> meaning of a specific kernel message, e.g. an error message of a
> driver. Especially on our mainframe zSeries platform system
> administrators want to have descriptions for Linux kernel messages.
> They are used to that, because all other operating systems on that
> platform like z/OS, z/VM or z/VSE have message catalogs with detailed
> descriptions about the semantics of the messages.

I'm not sure we want to make Linux more like z/* in this regard. :)

The problem with your proposal is that every time a new message in the
kernel is created or modified, you need somebody to go update that
documentation.  It's going to get out-of-sync very fast if this isn't
done, and you either need to convince and teach each and every kernel
contributor to follow your lead, or have a team of highly trained code
monkeys to watch git-commits and resubmit documentation for every diff
that touches a printk. 

I think it's a great idea to go and update some of these obtuse kernel
messages with more understandable wording.  It might even be nice to
update the Documentation/ about what kinds of messages are good or bad
to have.  But, I just don't think this is viable to convince everybody
to do this.  Do you have a list of printks that are causing your
customers trouble?

Does every printk need one of these?  What do we do with the existing
printks?  Who will convert them over?  How do we enforce the rules if
new printks must have documentation written for them?  Who writes the
documentation if the printk author does not?

If we have a catalog of kernel messages, it obviously needs to be
versioned, but does that mean that we need to keep it in the kernel
tree?

-- Dave

