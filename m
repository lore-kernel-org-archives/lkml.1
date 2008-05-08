Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYEHHvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYEHHvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYEHHvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:51:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:58485 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYEHHvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:51:07 -0400
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080508093421.31cd735b@gondolin.boeblingen.de.ibm.com>
References: <20080424043400.GS20457@bakeyournoodle.com>
	 <20080506143936.6357e578.akpm@linux-foundation.org>
	 <20080506.144301.233784820.davem@davemloft.net>
	 <1210121683.21644.194.camel@pasglop>
	 <20080506182006.4b4a3968.akpm@linux-foundation.org>
	 <1210134804.21644.202.camel@pasglop>
	 <20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
	 <1210196621.1421.5.camel@pasglop>
	 <20080508093421.31cd735b@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 17:49:44 +1000
Message-Id: <1210232984.1421.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 09:34 +0200, Cornelia Huck wrote:
> 
> I was under the impression that failing the initialization was usually
> the right thing to do, since we end up with an un-configurable,
> un-usable device. But that may be coloured by my experience with s390
> devices, where we rely on sysfs attributes extensively. If indeed most
> sysfs files are non-vital, removing the __must_check and relying on a
> scary warning in the core may be fine. (OTOH, adding checks to the
> core
> has helped us to find some lurking bugs.)

The driver can still fail initialization if it wants... I'm just
objecting to the __must_check.

Ben.


