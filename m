Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYEJEkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYEJEkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 00:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYEJEkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 00:40:33 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:57410 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbYEJEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 00:40:32 -0400
X-Authority-Analysis: v=1.0 c=1 a=frr7tnlS5JwA:10 a=j7aJu_usDzAA:10
 a=ZH8D7TI2ClAGQ7-6gXUA:9 a=qY4aZw6bRTFnKNLj3V7a_0zDSkIA:4 a=7DSvI1NPTFQA:10
 a=dGJ0OcVc7YAA:10 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: [regression?] distcc says: (dcc_pump_sendfile) ERROR: sendfile
	returned 0? can't cope (bisected)
From: Tom Zanussi <zanussi@comcast.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080509191734.GX16217@kernel.dk>
References: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com>
	 <20080507211641.GR16217@kernel.dk> <1210231275.7301.17.camel@charm-linux>
	 <1210306939.7205.9.camel@charm-linux> <20080509112651.GR16217@kernel.dk>
	 <e9c3a7c20805091101w6402c17ak5dbee048a1845753@mail.gmail.com>
	 <20080509191734.GX16217@kernel.dk>
Content-Type: text/plain
Date: Fri, 09 May 2008 23:40:29 -0500
Message-Id: <1210394429.7422.4.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-09 at 21:17 +0200, Jens Axboe wrote:
> On Fri, May 09 2008, Dan Williams wrote:
> > On Fri, May 9, 2008 at 4:26 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > >  Dan, can I talk you into re-trying current git with this patch applied?
> > >  It's basically the (now) reverted broken bits plus the fix from Tom from
> > >  this email.
> > >
> > 
> > distcc appears to be  happy.
> > 
> > Tested-by: Dan Williams <dan.j.williams@intel.com>
> 
> Super, Tom I already committed this patch as coming from you. If you
> want a SOB added, let me know.
> 

OK, great, thanks.

Signed-off-by: Tom Zanussi <zanussi@comcast.net>


