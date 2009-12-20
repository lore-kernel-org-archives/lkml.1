Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZLTMTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZLTMTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZLTMTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:19:41 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57824 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZLTMTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:19:41 -0500
Date: Sun, 20 Dec 2009 13:18:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Michal Marek <mmarek@suse.cz>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
	boot
Message-ID: <20091220121853.GA6683@merkur.ravnborg.org>
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org> <4B2E084D.6080105@msgid.tls.msk.ru> <m2y6kxetu8.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2y6kxetu8.fsf@igel.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 01:02:55PM +0100, Andreas Schwab wrote:
> Michael Tokarev <mjt@tls.msk.ru> writes:
> 
> > Sam Ravnborg wrote:
> >> We use ... printf \x ... when calculating the size of the
> >> compressed kernel.
> >> Unfortunately dash built-in printf does not support this notation
> >> resulting in a non-bootable kernel.
> >> 
> >> Fix this by always using the external version of printf.
> 
> That changed the wrong printf. :-)

Right - I have it correct in my repo here but "git commit --amend" fooled me.

	Sam
