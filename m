Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYGXUwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYGXUwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYGXUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:52:32 -0400
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:60465 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751301AbYGXUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:52:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=tV22rrS1efLNbUxwHZqQwF27lAx/07SwbwaBbhAojDQijSA2QQidOBSO8lbBVV0DuGsHlErqvtR0y+tsqxMztSp/hVE+i/O7NxxdHYc96cMoXgWrLb3DHeS3OJjQcAiY;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/4] sky2: Adapt sky2 to use reworked PCI PM
Date: Thu, 24 Jul 2008 13:52:18 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
References: <200807191436.40726.rjw@sisk.pl> <20080720190742.84258d7e.akpm@linux-foundation.org> <200807242250.51119.rjw@sisk.pl>
In-Reply-To: <200807242250.51119.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241352.18947.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2008 1:50 pm Rafael J. Wysocki wrote:
> [Sorry for the delayed response, I'm at OLS.]
>
> On Monday, 21 of July 2008, Andrew Morton wrote:
> > On Sat, 19 Jul 2008 14:42:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> 
wrote:
> > > Adapt the sky2 driver to use the reworked PCI PM.
> >
> > I fixed the rejects in "[PATCH 3/4] tg3: Adapt tg3 to use reworked PCI
> > PM code" but this patch has too many for me to want to fix them.
> >
> > As usual, please at least take a look at what's in linux-next before
> > going and bypassing all that queued work.
>
> Sorry for that.
>
> Appended is a version of the patch applying to the current mainline on top
> of patches 1/4 - 3/4 without rejects.
>
> BTW, the sky2's WOL is broken on my test box because of commit
> db99b98885e717454feef1c6868b27d3f23c2e7c ("sky2: put PHY in sleep when
> down") that causes the box to hang solid in sky2_suspend() and
> sky2_shutdown() after WOL has been enabled with 'ethtool -s eth0 wol g'.
>
> This has already been reported to Stephen and Jeff.

Btw, I just asked Linus to pull the 2/4 part of this patchset, so the rest 
should be able to go upstream soon.

Thanks,
Jesse
