Return-Path: <linux-kernel-owner+w=401wt.eu-S937628AbXG0R3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937628AbXG0R3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764442AbXG0R3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:29:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:64597 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937453AbXG0R3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:29:16 -0400
X-IronPort-AV: E=Sophos;i="4.16,589,1175497200"; 
   d="scan'208";a="86630689"
Subject: Re: NFSv4 poops itself
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Dr. J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <46AA2872.9040800@garzik.org>
References: <46A9EAB0.3090306@garzik.org>
	 <1185543187.6586.10.camel@localhost> <1185556178.6586.40.camel@localhost>
	 <46AA2872.9040800@garzik.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Fri, 27 Jul 2007 13:29:00 -0400
Message-Id: <1185557340.6586.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 27 Jul 2007 17:29:01.0159 (UTC) FILETIME=[9F0CEF70:01C7D073]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 13:16 -0400, Jeff Garzik wrote:
> Trond Myklebust wrote:
> > Jeff and Bruce, could you please try to reproduce the problem after
> > either applying patches 001 to 004 or just the single NFS_ALL patch
> > from 
> > 
> >    http://client.linux-nfs.org/Linux-2.6.x/2.6.23-rc1/
> 
> 
> It's not easily reproducible here.  Any hints on triggering the behavior?

I suspect that the problem may involve mixing O_RDWR with O_RDONLY
and/or O_WRONLY file access. Bruce might have a better suggestion,
though.
