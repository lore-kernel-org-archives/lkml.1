Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYIBPPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYIBPPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYIBPPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:15:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42826 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYIBPPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:15:35 -0400
Date: Tue, 2 Sep 2008 11:06:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
       Zhu Yi <yi.zhu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org,
       Jan-Espen Pettersen <sigsegv@radiotube.org>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080902150625.GC3050@tuxdriver.com>
References: <20080901160658.GA11063@google.com> <1220319536.28282.128.camel@debian.sh.intel.com> <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net> <20080902130429.GB19172@google.com> <1220362201.3176.4.camel@borkbork.foobar.com> <20080902145840.GE19172@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902145840.GE19172@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 05:58:41PM +0300, Michael S. Tsirkin wrote:
> On Tue, Sep 02, 2008 at 09:30:01AM -0400, Dan Williams wrote:
> > On Tue, 2008-09-02 at 16:04 +0300, Michael S. Tsirkin wrote:

> > > But it happens to work fine without 8ab65b03b7893da4a49009e7e356e36e27b0c407.
> > 
> > That's really odd; that patch (the don't-send-empty-extended-rates-IE
> > patch) shouldn't have anything to do with this behavior, if it did you
> > wouldn't get associated to the AP in the first place I think.  You're
> > 100% sure that this patch is causing the problem?
> 
> No, not sure. But reverting it seems to have helped.
> And there does not seem to be anything else relevant between rc4 and
> rc5.

So you determined that commit by eye rather than by git bisect?
Any chance I could talk you into confirming that using git bisect?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
