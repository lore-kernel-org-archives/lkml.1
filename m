Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZJ3OXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZJ3OXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932202AbZJ3OXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:23:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:57144 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbZJ3OXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FADnm1NdD0GZ5mdsIH0IHoiNuPM1IBGk9hyHrgQKwcMXDJiTwln1y7B8kfrZE9nDUb
         9gHID9XOUHFE6Aop5kzGmrpeIn9WH/VoSMMcpBAj7zrirBbG2/gqkSiZu1B0bQaPMS7P
         Z7THI3uVrsmAzpA8owyUS6tbjO6c1egKB+KcE=
Date: Fri, 30 Oct 2009 15:23:50 +0100
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mel LKML <mel.lkml@gmail.com>, Frans Pop <elendil@planet.nl>,
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
Message-ID: <20091030142350.GA9343@bizet.domek.prywatny>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <20091023165810.GA4588@bizet.domek.prywatny> <20091023211239.GA6185@bizet.domek.prywatny> <9ec2d7290910240646p75b93c68v6ea1648d628a9660@mail.gmail.com> <20091028114208.GA14476@bizet.domek.prywatny> <20091028115926.GW8900@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028115926.GW8900@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 11:59:26AM +0000, Mel Gorman wrote:
> On Wed, Oct 28, 2009 at 12:42:08PM +0100, Karol Lewandowski wrote:
> > On Sat, Oct 24, 2009 at 02:46:56PM +0100, Mel LKML wrote:
> > I've tested patches 1+2+3+4 in my normal usage scenario (do some work,
> > suspend, do work, suspend, ...) and it failed today after 4 days (== 4
> > suspend-resume cycles).
> > 
> > I'll test 1-5 now.

2.6.32-rc5 with patches 1-5 fails too.


> Also, what was the behaviour of the e100 driver when suspending before
> this commit?
> 
> 6905b1f1a03a48dcf115a2927f7b87dba8d5e566: Net / e100: Fix suspend of devices that cannot be power managed

This was discussed before with e100 maintainers and Rafael.  Reverting
this patch didn't change anything.


Thanks.
