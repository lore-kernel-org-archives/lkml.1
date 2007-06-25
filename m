Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXFYS20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXFYS20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXFYS2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:28:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbXFYS2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:28:15 -0400
Date: Mon, 25 Jun 2007 11:27:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Christoph Lameter <clameter@sgi.com>,
       Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Samuel Ortiz <samuel@sortiz.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: [2/2] 2.6.22-rc6: known regressions with patches
In-Reply-To: <467F8F63.2070101@googlemail.com>
Message-ID: <alpine.LFD.0.98.0706251126040.3593@woody.linux-foundation.org>
References: <467F894C.4000604@googlemail.com>
 <467F8F63.2070101@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jun 2007, Michal Piotrowski wrote:
> 
> Memory management
> 
> Subject    : bug in i386 MTRR initialization
> References : http://lkml.org/lkml/2007/5/19/93
> Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
> Status     : patch available

This one wasn't a bug in the first place, it was just the regular warning 
for kmalloc-size-0. The "BUG" string was confusing and has been fixed, and 
the warning for size-0 has gone away and been replaced by returning a 
pointer that will fault on dereference instead.

So please remove this one.

		Linus
