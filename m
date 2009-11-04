Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbZKDWAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbZKDWAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbZKDWAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:00:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37649 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbZKDWAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:00:13 -0500
Date: Wed, 4 Nov 2009 17:00:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Harald Arnesen <harald@skogtun.org>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #14372] ath5k wireless not working after rfkill [BISECTED]
Message-ID: <20091104220002.GH10786@tuxdriver.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.xRH.vre5KB@chimera> <b637ec0b0910261315u43033948ge041cf70292bfa58@mail.gmail.com> <87aazddvft.fsf@basilikum.skogtun.org> <20091104200714.GA24699@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104200714.GA24699@sucs.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 08:07:14PM +0000, Sitsofe Wheeler wrote:
> On Tue, Oct 27, 2009 at 10:42:46AM +0100, Harald Arnesen wrote:
> > Fabio Comolli <fabio.comolli@gmail.com> writes:
> > 
> > > Still present in -rc5
> 
> Help. I've just bisected this down to the same commit
> b56ab33d68638e6aafdbfc694025e8354a628f49 (that will teach me for not
> reading the whole thread) as I have the same problem on my EeePC 900.
> 
> Still present in -rc6 and the latest git.

Thank you for taking the time to bisect this!

I move that we revert it.  It appears to be a work-around for a staging
driver that causes problems for a non-staging one...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
