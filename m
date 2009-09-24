Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZIXAzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZIXAzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZIXAzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:55:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:45103 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZIXAzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:55:07 -0400
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20090916074848.GB4870@osiris.boeblingen.de.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
	 <1253016701.5506.73.camel@laptop> <20090915145834.GG4846@balbir.in.ibm.com>
	 <20090916074848.GB4870@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:52:46 +1000
Message-Id: <1253753566.7103.359.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 09:48 +0200, Heiko Carstens wrote:
> FWIW, this sounds exactly like the same we have already on s390.
> But back then I didn't consider adding a common code infrastructure
> would make sense :)
> 
> Besides the "online" attribute we have an additional "configure"
> attribute to which can only be written if the cpu is offline.
> Writing a "0" to it would mean that you currently won't need the cpu
> anymore and the hypervisor is free to reassign the cpu to a different
> LPAR.
> Writing a "1" to it means you want to use it. If there are enough
> resources you will get it. If not.. bad luck.
> 
Maybe we should use a common API for that then. And the right way to do
so is via a generically located attribute.

Ben.


