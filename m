Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXFNP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXFNP0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXFNPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:25:42 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:48980 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbXFNPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:25:40 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
In-Reply-To: <20070614122639.GI13141@duck.suse.cz>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
	 <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
	 <1181817533.10064.18.camel@localhost.localdomain>
	 <1181821661.10064.27.camel@localhost.localdomain>
	 <20070614122639.GI13141@duck.suse.cz>
Content-Type: text/plain
Organization: IBM
Date: Thu, 14 Jun 2007 17:22:01 +0200
Message-Id: <1181834521.10064.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 14:26 +0200, Jan Kara wrote:

<snip>

> > But maybe also 4 bytes would be enough, since the hash only has to be
> > unique within one component e.g. "hub".
>   It depends how large components you expect. For example for 10000
> messages there is already 1% probability of collision so it means sooner or
> later we are going to hit it... For 1000 messages the probability is
> roughly 0.1% which is still not so small that I'd be comfortable with it.

I wouldn't expect, that a "normal" component like a device driver will
have more than 100 documented messages.

Collisions are ugly, but will not hurt much. The operator will see for a
message two possible descriptions. Normally it should be possible to
figure out manually which description is the right one.

Michael

