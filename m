Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZJ1LmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZJ1LmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZJ1LmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:42:11 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52146 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZJ1LmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wy8QXKLI0jxb0T0NVxJWJQ6bRczeixo0ofgoRgrZR4VPR86jmr+BLCPiPjnfFGfs84
         2OKdQHZfZsmMorM+P7RTEheuwtObK1C3rPBq5QAg4YxNmPTT/mrRzwtyTMmuIM0QAOWS
         oqwSOa1YR2XQf4uUxPRL/Mo5cBfZ8qLerzYds=
Date: Wed, 28 Oct 2009 12:42:08 +0100
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel LKML <mel.lkml@gmail.com>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
	failures V2
Message-ID: <20091028114208.GA14476@bizet.domek.prywatny>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <20091023165810.GA4588@bizet.domek.prywatny> <20091023211239.GA6185@bizet.domek.prywatny> <9ec2d7290910240646p75b93c68v6ea1648d628a9660@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ec2d7290910240646p75b93c68v6ea1648d628a9660@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 02:46:56PM +0100, Mel LKML wrote:
> Hi,

Hi,

> On 10/23/09, Karol Lewandowski <karol.k.lewandowski@gmail.com> wrote:
> > On Fri, Oct 23, 2009 at 06:58:10PM +0200, Karol Lewandowski wrote:

> > Ok, I've tested patches 1+2+4 and bug, while very hard to trigger, is
> > still present. I'll test complete 1-4 patchset as time permits.

Sorry for silence, I've been quite busy lately.


> And also patch 5 please which is the revert. Patch 5 as pointed out is
> probably a red herring. Hwoever, it has changed the timing and made a
> difference for some testing so I'd like to know if it helps yours as
> well.

I've tested patches 1+2+3+4 in my normal usage scenario (do some work,
suspend, do work, suspend, ...) and it failed today after 4 days (== 4
suspend-resume cycles).

I'll test 1-5 now.


Thanks.
