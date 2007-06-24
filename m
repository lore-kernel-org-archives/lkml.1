Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbXFXMnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbXFXMnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 08:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXFXMnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 08:43:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbXFXMnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 08:43:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Date: Sun, 24 Jun 2007 14:48:18 +0200
User-Agent: KMail/1.9.5
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
References: <20070606231642.GH13751@tree.beaverton.ibm.com> <200706240154.53351.rjw@sisk.pl> <20070624002836.GB25516@linux-os.sc.intel.com>
In-Reply-To: <20070624002836.GB25516@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706241448.18749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 June 2007 02:28, Siddha, Suresh B wrote:
> On Sun, Jun 24, 2007 at 01:54:52AM +0200, Rafael J. Wysocki wrote:
> > This patch breaks hibernation on my Turion 64 X2 - based testbox (HPC nx6325).
> > 
> > _cpu_down() just hangs as though there were a deadlock in there, 100% of the
> > time.
> 
> Does the patch at this URL work for you?
> 
> http://marc.info/?l=linux-kernel&m=118228358826737&w=2

Yes, it does.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
