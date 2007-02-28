Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbXB1LBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbXB1LBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXB1LBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:01:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48315 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbXB1LBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:01:36 -0500
Date: Wed, 28 Feb 2007 16:31:22 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070228110122.GC15509@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702261139.59130.rjw@sisk.pl> <20070227215314.GA427@tv-sign.ru> <20070228012301.GH29179@in.ibm.com> <200702281157.28381.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702281157.28381.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 11:57:27AM +0100, Rafael J. Wysocki wrote:
> Which is because we don't want the kernel threads to be frozen in unexpected
> places, so we allow them to block freeze_processes() instead or to set
> PF_NOFREEZE?

Looks good!

-- 
Regards,
vatsa
