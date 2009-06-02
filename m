Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZFBN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZFBN02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZFBN0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:26:16 -0400
Received: from ryu.zarb.org ([212.85.158.22]:39419 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbZFBN0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:26:16 -0400
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
From: Pascal Terjan <pterjan@mandriva.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200905292147.05395.rjw@sisk.pl>
References: <1243625720.4426.0.camel@plop>  <200905292147.05395.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Tue, 02 Jun 2009 15:26:15 +0200
Message-Id: <1243949175.19053.97.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1-1mdv2009.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 mai 2009 à 21:47 +0200, Rafael J. Wysocki a écrit :
> On Friday 29 May 2009, Pascal Terjan wrote:
> > (Resending because of wrong To:, sorry for the duplicate)
> > 
> > We have a machine here where hard disk is no longer detected at boot
> > time with 2.6.29.3 (it happens only on kernels with HIGHMEM4G + PAE and
> > not on the same one with HIGHMEM64G). 
> >
> > Motherboard is ECS PF22 Extreme
> > 
> > bisect blames this commit:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=3b442bfc78d351343fa539c63afde75d7b134316
> 
> Would it be possible to check if the current mainline works correctly?

2.6.30-rc7 has the same issue

