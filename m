Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZECTq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZECTq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZECTqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:46:49 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36529 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZECTqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:46:48 -0400
Date: Sun, 3 May 2009 21:48:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Anders Kaseorg <andersk@MIT.EDU>, Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jean Delvare <khali@linux-fr.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modpost: more complete endianness fixing
Message-ID: <20090503194848.GA32400@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare> <20090503103010.GA27978@uranus.ravnborg.org> <20090503204218.6c65c740.sfr@canb.auug.org.au> <alpine.DEB.2.00.0905031403300.28205@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.0905031403300.28205@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 02:07:35PM -0400, Anders Kaseorg wrote:
> Fix endianness of all the fields in the ELF header and section headers, 
> not just some of them.
> 
> The missing TO_NATIVE(sechdrs[i].sh_flags) was causing many “unexpected 
> non-allocatable section” warnings when cross-compiling for an architecture 
> with a different endianness.

Thanks Anders.
Makes sense for the powerpc case.
But I cannot see it fixing the warnings Jean sees.

Jean?

	Sam
