Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZJDT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZJDT2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbZJDT2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:28:42 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50116 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbZJDT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v8br/sCvK9t6y/gsvCS2Pf8uTKvsUIuRQgYHMGpR9XRwg5NF2w3BjZyZjianxX6q52
         5lOV9NVz/j76+MbqaZJPKZffb3jxmHlFu89OzNPvv252502yx/N2OmI+w2Hts68/zhSZ
         DaM6c9CxHVXfAIPxvAeWOWR+3RhvwGt7r2Oio=
Date: Sun, 4 Oct 2009 21:28:00 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091004192800.GA6442@bizet.domek.prywatny>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.k2B.ZNTxKB@chimera> <200910021111.55749.elendil@planet.nl> <20091002093226.GJ21906@csn.ul.ie> <20091002200143.GA3845@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002200143.GA3845@bizet.domek.prywatny>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 10:01:43PM +0200, Karol Lewandowski wrote:
> On Fri, Oct 02, 2009 at 10:32:26AM +0100, Mel Gorman wrote:
> > Apparently, Karol Lewandowski (cc added) has a reliable
> > reproduction case for when the firmware loading problem occurs
> > (http://lkml.org/lkml/2009/9/30/242). While it's not the same problem exactly,
> > it's probable they're related. I'm hoping the problem commit can be identified
> > by his bisection whenever he gets around to it.
> 
> Unfortunately, I've had little success with bisecting this problem.
> I've spend fair amount of time today trying to reproduce this problem,
> but I'm unable to do so even on kernels that failed "easily" before.

I've been able to reproduce this problem on 2.6.32-rc1.  No "luck"
with bisecting, though.
