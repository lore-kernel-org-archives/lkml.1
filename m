Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZCKSaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZCKSaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZCKSae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:30:34 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33233 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbZCKSad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:30:33 -0400
Date: Wed, 11 Mar 2009 14:19:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gabor Juhos <juhosg@openwrt.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
Message-ID: <20090311181935.GD8761@tuxdriver.com>
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org> <49B17C4E.3000004@oracle.com> <20090306194045.GE3712@tuxdriver.com> <49B7F2B0.1000702@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49B7F2B0.1000702@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:19:44AM -0700, Randy Dunlap wrote:
> John W. Linville wrote:
> > On Fri, Mar 06, 2009 at 11:41:02AM -0800, Randy Dunlap wrote:
> >> Gabor Juhos wrote:
> >>> Randy Dunlap írta:
> >>>> Stephen Rothwell wrote:
> >>>>> Hi all,
> >>>>>
> >>>>> Linus' release of -rc7 seems to have stirred people up a bit ...
> >>>>>
> >>>>> Changes since 20090305:
> >>>> when CONFIG_RFKILL=n, ath9k/virtual.c causes:
> >>>>
> >>>> (.text+0x224e83): undefined reference to `ath_radio_disable'
> >>>> (.text+0x224e8b): undefined reference to `ath_radio_enable'
> >>>>
> >>>>
> >>> Hi,
> >>>
> >>> I have submitted a patch for this already:
> >>> http://marc.info/?l=linux-wireless&m=123633468314970&w=2
> >>>
> >>> Should I send it to somewhere else as well?
> >> It hasn't propagated into the linux-next merging yet...
> > 
> > He just sent it today (or overnight).  I'll get it into wireless-next.
> > 
> > John
> > 
> > P.S.  I'm starting to think that RFKILL should just be mandatory...
> 
> 
> This build error still happens in linux-next-20090311.

That fix is in wireless-next-2.6 as of yesterday.  I guess it was a
little too late for yesterday's linux-next build -- sorry!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
