Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbZBISNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbZBISNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZBISNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:13:41 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9902 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbZBISNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:13:40 -0500
Date: Mon, 9 Feb 2009 11:13:38 -0700
From: Alex Chiang <achiang@hp.com>
To: tony.luck@intel.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] ia64: prevent irq migration race in __cpu_disable
	path
Message-ID: <20090209181338.GD19064@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, tony.luck@intel.com,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
	linux-ia64@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of my attempt to prevent an oops while offlining CPUs.

The change is that the patch becomes a full revert of Paul's
original patch, along with a long changelog that explains the
situation as best as I can determine. It's not 100% satisfactory
to me right now, but the testing we've done supports the patch.

The 2nd patch in the series is mostly cosmetic, and removes a
redundant call to cpu_clear() that we no longer need().

Tony, if you agree with the rationale in 1/2, then this series is
a candidate for .29.

stable team, if Tony pushes upstream for .29, then this series
should be applied to the .27 and .28 stable series.

Thanks.

/ac

