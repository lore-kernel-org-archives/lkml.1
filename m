Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYG3Rzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYG3Rzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYG3Rzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:55:37 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:39633 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYG3Rzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:55:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=TrhifMvm8AZWDleEJcSc1v8RUkunfICbRWxgN7kQAhZ2Upgfu1BBSP3ugQwVSVyvTNKyXIjEh04khMeOcktYDwW+vkIYZBFyCayhWXHrWKR4GnCjbPXwsOoBB0PSwMNe;
Message-ID: <4890AAB5.7070001@simon.arlott.org.uk>
Date: Wed, 30 Jul 2008 18:53:57 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Jon Smirl <jonsmirl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>,
       rol@witbe.net, Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 463 kernel developers missing!
References: <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>	<20080728202236.GN9378@mit.edu>	<20080728204624.GA11581@redhat.com>	<20080728141414.d7e5def2.randy.dunlap@oracle.com>	<Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au>	<20080728234131.GD28055@linux-sh.org>	<9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com>	<488E644D.7000507@keyaccess.nl>	<9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com>	<488EF377.5080603@keyaccess.nl>	<20080730072448.GB1564@cs181140183.pp.htv.fi>	<489061E0.5000501@keyaccess.nl> <20080730145822.3c3253f2@tux.DEF.witbe.net>
In-Reply-To: <20080730145822.3c3253f2@tux.DEF.witbe.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/08 13:58, Paul Rolland wrote:
> We could blame Jon for publishing the his list on the list without prior 
> information, but not for creating it. 
> And I certainly would like to see the .mailmap appear at my next git pull ;)

The fact still remains that most of the entries in Jon's .mailmap file are 
redundant. I may have three email addresses referred to in git, but my name 
is the same in all cases. Until "git shortlog" is changed to link an author's 
commits without using their name there is no need to include me and several 
other people in there. Especially not anyone with only one email address 
in the commit log.

(It would also be easy to sha1 hash all the email addresses in the shortlog 
mailmap, using a hash lookup to find the name, although it would make it 
a bit difficult to find what any one address is without grepping the log.)

The ChangeLogs do include all email addresses contributing to that release, 
but in general I think a big list of them which people can use with no 
effort to spam every developer is a bad thing. On the other hand maybe 
those people don't know what .files are ;)

-- 
Simon Arlott
