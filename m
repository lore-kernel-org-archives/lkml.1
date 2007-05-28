Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbXE1Grv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbXE1Grv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 02:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXE1Gro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 02:47:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37779 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbXE1Grn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 02:47:43 -0400
Date: Mon, 28 May 2007 12:25:50 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Dipankar <dipankar@in.ibm.com>
Subject: Re: CPU hotplug: system hang on CPU hot remove during `pfmon --system-wide'
Message-ID: <20070528065550.GL6157@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 10:54:43AM +0900, Satoru Takeuchi wrote:
> Since I'm investigating this problem now, I'm glad if someone
> reports the test result on other arch or freezer.

I suspect the freezer based approach will not have this problem. Gautham
could probably verify that.

Andrew/Linus,
	So is it settled now on what approach we are going to follow (freezer 
vs lock based) for cpu hotplug? I thought that Linus was not favouring freezer 
based approach sometime back ..

-- 
Regards,
vatsa
