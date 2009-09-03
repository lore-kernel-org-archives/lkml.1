Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZICFT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZICFT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZICFT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:19:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53302 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbZICFT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:19:58 -0400
Date: Thu, 3 Sep 2009 15:15:16 +1000
From: Anton Blanchard <anton@samba.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Tim Pepper <lnxninja@linux.vnet.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       John Stultz <johnstul@us.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jamey Sharp <jamey@minilop.net>
Subject: Re: [RFC PATCH] Turn off the tick even when not idle
Message-ID: <20090903051516.GA9646@kryten>
References: <20090901154327.GA10024@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901154327.GA10024@feather>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Josh,

> The following patch (not for application any time soon) hacks away the
> timer interrupt even when not idle, by triggering the nohz mechanism
> even if not running the idle task.

Nice :) I tested it on a ppc64 box, and threw the graphs up here:

http://ozlabs.org/~anton/linux/osjitter/

With the patch applied, we saw only one interruption in the 10 second window
I measured.

Anton
