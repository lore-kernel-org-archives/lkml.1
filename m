Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbXDCTRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbXDCTRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXDCTRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:17:34 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:1782 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753557AbXDCTRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:17:33 -0400
Message-ID: <4612A854.1070702@cfl.rr.com>
Date: Tue, 03 Apr 2007 15:17:40 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Chris Snook <csnook@redhat.com>, Paa Paa <paapaa125@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com> <4612852C.2030801@rtr.ca>
In-Reply-To: <4612852C.2030801@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2007 19:17:41.0008 (UTC) FILETIME=[BFADB100:01C77624]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15094.000
X-TM-AS-Result: No--3.205200-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> But WD drives, in particular the Raptor series, have a firmware "feature"
> that disables "drive readahead" whenever NCQ is in use.

Why is this an issue?  Shouldn't the kernel be sending down its own 
readahead requests to keep the disk busy?



