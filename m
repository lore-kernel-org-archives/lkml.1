Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYEHXHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYEHXHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYEHXHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:07:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:60845 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYEHXHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:07:40 -0400
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <greg@kroah.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080508220348.GD7705@kroah.com>
References: <20080506143936.6357e578.akpm@linux-foundation.org>
	 <20080506.144301.233784820.davem@davemloft.net>
	 <1210121683.21644.194.camel@pasglop>
	 <20080506182006.4b4a3968.akpm@linux-foundation.org>
	 <1210134804.21644.202.camel@pasglop>
	 <20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
	 <1210196621.1421.5.camel@pasglop>
	 <20080508093421.31cd735b@gondolin.boeblingen.de.ibm.com>
	 <1210232984.1421.47.camel@pasglop>
	 <20080508103621.69bc47cf@gondolin.boeblingen.de.ibm.com>
	 <20080508220348.GD7705@kroah.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 09:06:37 +1000
Message-Id: <1210287997.1421.89.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 15:03 -0700, Greg KH wrote:
> Why?  You point out it found some real bugs, should we just assume
> that
> no new bugs of this same problem will happen again in the future?

Making sure it warns/printk's on error would probably find the same
bugs...

Ben.


