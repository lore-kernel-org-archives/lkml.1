Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbYFXPVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbYFXPVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYFXPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:21:32 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6727 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbYFXPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:21:31 -0400
Date: Tue, 24 Jun 2008 09:21:29 -0600
From: Alex Chiang <achiang@hp.com>
To: Robin Holt <holt@sgi.com>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECT] Boot failure on ia64.
Message-ID: <20080624152129.GB3599@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
	tony.luck@intel.com, linux-ia64@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080624123014.GJ10123@sgi.com> <20080624150851.GA3599@ldl.fc.hp.com> <20080624151715.GN10062@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624151715.GN10062@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robin Holt <holt@sgi.com>:
> I have not tried your patch yet.  Actually just read the email.
> Jack Steiner did point out that booting with force_pal_cache_flush on
> the command line will get it to boot.

Yes, that command line arg will get your kernel to boot because
it forces us to completely skip check_sal_cache_flush. It's
probably not what you want to be using long term, though.

> I will try your patch shortly and send you output.

Thanks.

/ac

