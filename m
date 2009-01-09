Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbZAIA1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbZAIA1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZAIA1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:27:40 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38683 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbZAIA1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:27:40 -0500
Subject: Re: [Patch 0/3] Overview, OProfile SPU event profiling support for
	IBM Cell processor
From: Carl Love <cel@us.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
In-Reply-To: <20090108154835.GQ15411@erda.amd.com>
References: <1228177106.6509.285.camel@carll-linux-desktop>
	 <20090108154835.GQ15411@erda.amd.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 16:26:31 -0800
Message-Id: <1231460791.6621.54.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-01-08 at 16:48 +0100, Robert Richter wrote:
> On 01.12.08 16:18:26, Carl Love wrote:
> > This is a rework of the previously posted set of patches.
> > 
> > Patch 1 is the user level patch to add the SPU events to the user
> > OProfile tool.  
> > 
> > Patch 2 is a kernel patch to do code clean up and restructuring to make
> > it easier to add the new SPU event profiling support.  This patch makes
> > no functional changes.
> > 
> > Patch 3 is a kernel patch to add the SPU event profiling support.
> 
> I applied patch 2 & 3 to:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git cell
> 
> The patches did not apply cleanly. I had to change the path to
> arch/powerpc/include/asm/, fix cell/pr_util.h and did some whitespace
> cleanups. Please run your tests on the cell branch.
> 
> Thanks,
> 
> -Robert
> 

I pulled down the git tree, compiled and installed it.  I tested it
against the OProfile testsuite, which includes SPU event profiling
tests.  Everything passed.  The patch I submitted was against a 2.6.26
tree.  You are now on a 2.6.28 tree so perhaps that is why the patch did
not apply cleanly.  The patch has been out there for some time.  

            Carl Love


