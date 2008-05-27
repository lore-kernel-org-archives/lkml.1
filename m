Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYE0OXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYE0OXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYE0OWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:22:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59804 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbYE0OWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:22:44 -0400
Date: Tue, 27 May 2008 07:15:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527071532.7a01608b@infradead.org>
In-Reply-To: <20080527131926.GB5181@dirshya.in.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
	<20080526085000.33787eac@infradead.org>
	<483AF25B.6090806@linux.vnet.ibm.com>
	<20080526110040.5ddc4656@infradead.org>
	<483B0348.2000204@linux.vnet.ibm.com>
	<20080526115108.6a19e2c0@infradead.org>
	<483C059B.9040301@linux.vnet.ibm.com>
	<20080527131926.GB5181@dirshya.in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 18:49:26 +0530
> At any time we will have both the traditional utilisation value
> relative to current CPU capacity, and scaled utilisation that is
> relative to maximum CPU capacity.
> 

this is where I raise a red flag *because the patch is not doing
that* !!

sadly it gives a random metric which in some circumstances looks like
it does that, but in reality it is not doing that.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
