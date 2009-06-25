Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZFYLwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZFYLwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZFYLwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:52:09 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:49908 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZFYLwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:52:07 -0400
Subject: Re: [PATCH 07/10] decnet: Use rcu_barrier() on module unload.
From: Jesper Dangaard Brouer <jdb@comx.dk>
Reply-To: jdb@comx.dk
To: Chrissie Caulfield <christine.caulfield@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       axboe@kernel.dk, Patrick McHardy <kaber@trash.net>,
       Trond.Myklebust@netapp.com, johannes@sipsolutions.net,
       yoshfuji@linux-ipv6.org, shemminger@linux-foundation.org,
       linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
       linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
       netfilter-devel@vger.kernel.org
In-Reply-To: <5A680E0A-EFEB-44EA-9F06-F338E6CBD6D1@googlemail.com>
References: <20090623150330.22490.87327.stgit@localhost>
	 <20090623150429.22490.15113.stgit@localhost>
	 <4A41C67E.8070301@googlemail.com>
	 <1245843884.6695.54.camel@localhost.localdomain>
	 <1245845367.24921.3.camel@localhost.localdomain>
	 <5A680E0A-EFEB-44EA-9F06-F338E6CBD6D1@googlemail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: ComX Networks A/S
Date: Thu, 25 Jun 2009 13:52:09 +0200
Message-Id: <1245930729.24921.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 14:50 +0100, Chrissie Caulfield wrote:
> I don't have any objection to the patch at all, 

Thus assuming an:

Acked-by: Chrissie Caulfield <christine.caulfield@googlemail.com>

(wondering if patchworks picks this up...)

> it just seemed a  
> little odd to deliberately add code inside #if 0 ;-)

Yes, but it makes sense if you want to fix that code path later on.

And I'm not the only one who have added code here... git blame:

fa34ddd7 (Thomas Graf              2007-03-22 11:57:46 -0700 2401)
457c4cbc (Eric W. Biederman        2007-09-12 12:01:34 +0200 2413)

Cheers,
                                  -- 
                    Med venlig hilsen / Best regards
                              Jesper Brouer
                            ComX Networks A/S
                         Linux Network developer
                       Cand. Scient Datalog / MSc.
                    Author of http://adsl-optimizer.dk
               LinkedIn: http://www.linkedin.com/in/brouer
