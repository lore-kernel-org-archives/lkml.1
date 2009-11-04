Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbZKDXLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbZKDXLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933060AbZKDXLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:11:11 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:33508 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932775AbZKDXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:11:10 -0500
Date: Wed, 04 Nov 2009 22:35:11 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Harald Arnesen <harald@skogtun.org>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #14372] ath5k wireless not working after rfkill [BISECTED]
Message-ID: <50BA90468C%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <20091104220002.GH10786@tuxdriver.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> 
 <6dRYo8ss7vL.A.xRH.vre5KB@chimera> 
 <b637ec0b0910261315u43033948ge041cf70292bfa58@mail.gmail.com> 
 <87aazddvft.fsf@basilikum.skogtun.org> <20091104200714.GA24699@sucs.org> 
 <20091104220002.GH10786@tuxdriver.com>
Mail-Followup-To: "John W. Linville" <linville@tuxdriver.com>, Sitsofe Wheeler 
 <sitsofe@yahoo.com>, Harald Arnesen <harald@skogtun.org>, Fabio Comolli 
 <fabio.comolli@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux Kernel 
 Mailing List <linux-kernel@vger.kernel.org>, Kernel Testers List 
 <kernel-testers@vger.kernel.org>, Len Brown <len.brown@intel.com>, Linus 
 Torvalds <torvalds@linux-foundation.org>, Darren Salt 
 <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.60.0.3101 (Qt/4.5.3) (Linux-x86_64)
X-NuLabour-Date: Wed, 9105 Dec 1984 22:35:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that John W. Linville may or may not have written...

> On Wed, Nov 04, 2009 at 08:07:14PM +0000, Sitsofe Wheeler wrote:
>> On Tue, Oct 27, 2009 at 10:42:46AM +0100, Harald Arnesen wrote:
>>> Fabio Comolli <fabio.comolli@gmail.com> writes:
>>>> Still present in -rc5
>> Help. I've just bisected this down to the same commit
>> b56ab33d68638e6aafdbfc694025e8354a628f49 (that will teach me for not
>> reading the whole thread) as I have the same problem on my EeePC 900.
>> Still present in -rc6 and the latest git.

> Thank you for taking the time to bisect this!

> I move that we revert it.  It appears to be a work-around for a staging
> driver that causes problems for a non-staging one...

Already in hand: a reversion patch was sent by Corentin Chary, and I have
mail from Len Brown saying that it has been applied. (The correct fix is
present in -rc5 and -rc6, so once this reversion is out of the way, I see no
reason not to close bug 13390.)

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
|   <URL:http://www.youmustbejoking.demon.co.uk/> (PGP 2.6, GPG keys)

About all some men accomplish in life is to send a son to Oxbridge.
