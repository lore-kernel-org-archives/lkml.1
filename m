Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYLLWC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYLLWC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 17:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYLLWCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 17:02:52 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:60182 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbYLLWCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 17:02:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPxsQkl5LCOr/2dsb2JhbADPbIJ9
X-IronPort-AV: E=Sophos;i="4.36,213,1228051800"; 
   d="scan'208";a="274902051"
Date: Sat, 13 Dec 2008 09:02:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, xfs@oss.sgi.com
Subject: Re: xfs: possible circular locking dependency detected
Message-ID: <20081212220243.GB22525@disturbed>
Mail-Followup-To: Wu Fengguang <fengguang.wu@intel.com>,
	David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, xfs@oss.sgi.com
References: <20081206132023.GA21235@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206132023.GA21235@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 09:20:24PM +0800, Wu Fengguang wrote:
> Hi Dave,
> 
> I got this warning while accessing xfs on usb storage.
> Is this a real problem?

False positive. I haven't had time to add and test the lockdep
annotation Peter created last week to allow us to avoid this,
but hopefully that will make it go away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
