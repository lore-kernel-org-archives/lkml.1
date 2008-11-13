Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYKMNbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYKMNbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYKMNa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:30:57 -0500
Received: from mail4.iitk.ac.in ([203.197.196.4]:53572 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYKMNa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:30:56 -0500
Date: Thu, 13 Nov 2008 19:37:36 +0000
From: Rahul Pydimukkala <prahul@cse.iitk.ac.in>
To: kyle <kylewong@southa.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: apache threads not balanced over all CPU cores, schedular problem or apache?
Message-ID: <20081113193733.GA19131@csews22.cse.iitk.ac.in>
References: <009401c9454c$6e3a8610$b902a8c0@kyle> <20081113143404.GC12750@csews22.cse.iitk.ac.in> <001f01c94585$799bf280$0a01a8c0@kylecea1512a3f> <20081113191241.GB14953@csews22.cse.iitk.ac.in> <008201c94591$870d73b0$0a01a8c0@kylecea1512a3f>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008201c94591$870d73b0$0a01a8c0@kylecea1512a3f>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:12 Thu 13 Nov     , kyle wrote:
> From: "Rahul Pydimukkala" <prahul@cse.iitk.ac.in>
> To: "kyle" <kylewong@southa.com>
> Cc: <linux-kernel@vger.kernel.org>
> Sent: Friday, November 14, 2008 3:12 AM
> Subject: Re: apache threads not balanced over all CPU cores, schedular 
> problem or apache?
> 
> 
> >Few of the cores are always left idle by default for power saving reasons.
> >There has been a discussion over it sometime back. 
> >http://lkml.org/lkml/2008/6/25/326
> >
> >That helps you play around with the load-balancer.
> >
> 
> Oh I never note this.
> 
> However, my current setting is "0".


http://lkml.org/lkml/2008/9/8/90  makes it more complete. It's probabaly time you upgrade to 2.6.27. 
Seems like the bug exists in 2.6.26 and was fixed only for 2.6.27.

-
Rahul    
 
