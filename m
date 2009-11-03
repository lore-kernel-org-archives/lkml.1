Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZKCV4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZKCV4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZKCV4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:56:46 -0500
Received: from kanga.kvack.org ([205.233.56.17]:49068 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZKCV4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:56:45 -0500
Date: Tue, 3 Nov 2009 16:56:50 -0500
From: Benjamin LaHaise <bcrl@lhnet.ca>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs directory scaling: rbtree for dirent name lookups
Message-ID: <20091103215650.GT8227@kvack.org>
References: <20091101163130.GA7911@kvack.org> <20091103035058.GA19515@kroah.com> <20091103200155.GQ8227@kvack.org> <m1my338fbi.fsf@fess.ebiederm.org> <m1y6mn708g.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6mn708g.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 01:43:43PM -0800, Eric W. Biederman wrote:
> I guess in particular what I would expect is that if we can do 35000
> interfaces in 63s with an O(N^2) algorithm.  Then we should be able to
> do 35000 interfaces with an O(NlogN) algorithm in under a second.
> Which for your application should make the time essentially flat in
> the number of interfaces.

That's the wrong way to interprete the numbers.  The 35000 number of 63s is 
the time that it takes 63s to add 5000 more interfaces in the 30,000 to 
35,000 range.  This includes the time required to add a point to point ip 
route on the interface and bring the interface up.

		-ben
