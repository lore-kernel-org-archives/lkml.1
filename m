Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbXHNShU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbXHNShU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXHNSg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:36:57 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:57144 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbXHNSg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:36:56 -0400
X-Greylist: delayed 1772 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 14:36:56 EDT
Message-ID: <46C1F55E.1020908@gmail.com>
Date: Tue, 14 Aug 2007 20:33:02 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: git@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch	-	scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>	 <200708131933.10125.m.kozlowski@tuxland.pl>	 <1187026955.2688.4.camel@laptopd505.fenrus.org>	 <1187037445.6628.98.camel@heimdal.trondhjem.org>	 <1187054366.2757.0.camel@laptopd505.fenrus.org>	 <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>	 <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>	 <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost>
In-Reply-To: <1187116082.32555.122.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 08:28 PM, Joe Perches wrote:

> On Tue, 2007-08-14 at 20:03 +0200, Rene Herman wrote:
>> "git info --maintainer drivers/ide/ide-cd.c" or some such would say "Alan 
>> Cox <alan@...>".
> 
> Perhaps maintainer(s), approver(s), listener(s)?
> 
> I think something like this should be a git-goal.
> What do the git-wranglers think?

I agree. If this thing has source management, let's use it.

> Until a time in the future when a system like that exists,
> I suggest keeping MAINTAINERS up-to-date with
> 
> F:	pattern
> 
> It'll be useful as git-set-maintainer seeds at least.

Yes. Seeing as how it's already been useful in updating the information it 
would be a shame to throw what you already did away. Don't underestimate how 
fast git-wranglers can implement stuff if they agree though... :-)

>> sticking  headers on every source file isn't nice anyway --
>> it's meta-information and the SCM can maintain it.
> 
> It's like looking at $CVS$ keywords.  Unsightly.

Again agree.

Rene.


