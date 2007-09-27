Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbXI0EG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbXI0EG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 00:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXI0EGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 00:06:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25694 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbXI0EGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 00:06:49 -0400
Date: Wed, 26 Sep 2007 21:05:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Mark Gross <mgross@linux.intel.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
Message-Id: <20070926210515.6725e745.randy.dunlap@oracle.com>
In-Reply-To: <20070927022440.GB25873@linux-sh.org>
References: <20070926223712.GA22029@linux.intel.com>
	<20070926224026.GA23218@linux.intel.com>
	<20070927022440.GB25873@linux-sh.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 11:24:40 +0900 Paul Mundt wrote:

> > +/* static helper functions */
> > +static s32 max_compare(s32 v1, s32 v2)
> > +{
> > +	if (v1 < v2)
> > +		return v2;
> > +	else
> > +		return v1;
> > +}
> > +
> > +static s32 min_compare(s32 v1, s32 v2)
> > +{
> > +	if (v1 < v2)
> > +		return v1;
> > +	else
> > +		return v2;
> > +}
> > +
> min()/max() instead?

Other code wants function pointers to the min & max functions.
That's why they are here AFAICT.


> > +/* assumes qos_lock is held */
> > +static void update_target(int i)
> > +{
> 'target' might be a more meaningful variable name.

Anything but 'i'.

---
~Randy
Phaedrus says that Quality is about caring.
