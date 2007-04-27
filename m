Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbXD0NEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbXD0NEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXD0NEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:04:01 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:48231 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790AbXD0ND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:03:57 -0400
Subject: Re: [PATCH 2.6.22 5/5] iw_cxgb3: Update required firmware revision
	to 4.0.0.
From: Steve Wise <swise@opengridcomputing.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: jeff@garzik.org, divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <adaps5qo6hh.fsf@cisco.com>
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>
	 <20070426202126.24234.71523.stgit@dell3.ogc.int>
	 <adaps5qo6hh.fsf@cisco.com>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 08:03:56 -0500
Message-Id: <1177679036.10490.15.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 20:12 -0700, Roland Dreier wrote:
>  > Update required firmware revision to 4.0.0.
> 
> Hmm... should we fold this into the earlier patch, which actually
> needs this new FW?  Or at least merge this patch first?
> 

I separated it only because cxgb3 is maintained by Jeff.  Feel free to
make it one commit.  That is the proper way IMO. But I didn't know what
SOP was for changes that hit different maintainers but are prerequisites
of each other...


> Also, is it cool with everyone to require a new FW, even for users who
> might not be using (or even building) the RDMA driver?  I'm not sure
> what a good solution would be really, so maybe the pain of forcing
> everyone to update FW is the least bad thing to do.
>  - R.

I was asked to package the firmware version change along with my rdma
changes by Divy since they didn't have any other cxgb3 changes right
now.  I believe Chelsio wants folks on this new firmware asap.


Steve.





