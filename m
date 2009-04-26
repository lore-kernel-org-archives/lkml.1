Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZDZGyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZDZGyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 02:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZDZGy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 02:54:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59362 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbZDZGyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 02:54:24 -0400
Subject: Re: Large Pages - Linux Foundation HPC
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Vivek Kashyap <vivk@us.ibm.com>, Mel Gorman <mel@linux.vnet.ibm.com>,
       Robert MacFarlan <Robert_MacFarlan@us.ibm.com>,
       "Fu, Michael" <michael.fu@intel.com>
In-Reply-To: <20090425084804.GA517@localhost>
References: <1240331533.32731.2.camel@badari-desktop>
	 <1240333025.32604.392.camel@nimitz>
	 <20090421182555.GA8977@balbir.in.ibm.com>  <20090425084804.GA517@localhost>
Content-Type: text/plain
Date: Sat, 25 Apr 2009 23:54:21 -0700
Message-Id: <1240728861.29485.41.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-25 at 16:48 +0800, Wu Fengguang wrote:
> Based on Dave's descriptions that HPC apps typically
> - do mlock(), to pre-populate memory and pin them in memory
> - run at fresh boot, with loads of high order pages available

There are definitely some of them that do this, but it certainly isn't
all.  It may not even be the norm.  

-- Dave

