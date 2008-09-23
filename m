Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYIWUS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYIWUS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYIWUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:18:48 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:46455 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbYIWUSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:18:48 -0400
Subject: Re: [PATCH 3/4] TPM: rcu locking
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       serue@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com, debora@linux.vnet.ibm.com
In-Reply-To: <20080923181922.GE6637@linux.vnet.ibm.com>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
	 <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com>
	 <20080923181922.GE6637@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 17:18:17 -0300
Message-Id: <1222201097.24276.12.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Tue, 2008-09-23 at 11:19 -0700, Paul E. McKenney wrote:
> 
> But here we are deleting from what appears to be some other list.
> And I don't see any insertiong into either list.
> 
> What am I missing here?
> 
>                                                         Thanx, Paul

Sorry, forgot to change list_add() to list_add_rcu() in the code section
below:

> > +     /* Make chip available */
> > +     spin_lock(&driver_lock);
> > +     list_add(&chip->list, &tpm_chip_list);
> > +     spin_unlock(&driver_lock);

I'll resubmit.

Thanks,
Rajiv Andrade
IBM Linux Technology Center
Security Dev.

