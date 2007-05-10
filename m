Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbXEJOXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbXEJOXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762030AbXEJOXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:23:43 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:3163 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761708AbXEJOXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:23:42 -0400
Message-ID: <46432AF8.9050505@cfl.rr.com>
Date: Thu, 10 May 2007 10:23:52 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <alpine.LFD.0.98.0705081123080.3974@woody. <46424D44.2040003@s5r6.in-berlin.de>
In-Reply-To: <46424D44.2040003@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2007 14:23:49.0678 (UTC) FILETIME=[D3DEFCE0:01C7930E]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15168.000
X-TM-AS-Result: No--1.459300-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> The SCSI stack already has infrastructure for multi-threaded discovery
> and probing.

So?  It would still benefit from using a generic framework that other 
buses can use as well.  Not to mention that the current scsi specific 
framework tends to cause unstable names doesn't it?

