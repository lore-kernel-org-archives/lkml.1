Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbXDMQnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbXDMQnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbXDMQnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:43:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbXDMQnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:43:04 -0400
Message-ID: <461FB303.2060303@redhat.com>
Date: Fri, 13 Apr 2007 12:42:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Badari Pulavarty <pbadari@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cache_k8_northbridges() overflows beyond allocation (Was:
 2.6.21-rc5-mm4 (SLUB))
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com> <1176477222.8559.4.camel@dyn9047017100.beaverton.ibm.com> <200704131745.37795.ak@suse.de>
In-Reply-To: <200704131745.37795.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> cache_k8_northbridges() is storing config values to incorrect locations
>> (in flush_words) and also its overflowing beyond the allocation, causing
>> slab verification failures.
> 
> Oops. Thanks for tracking that down, Badari.
> 
> Andrew, clear .21 candidate.
> 

2.6.20 as well. Do you want me to submit it?

