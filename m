Return-Path: <linux-kernel-owner+w=401wt.eu-S1766910AbXDSRzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766910AbXDSRzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766913AbXDSRzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:55:05 -0400
Received: from mtaout1.012.net.il ([84.95.2.1]:41076 "EHLO mtaout1.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766910AbXDSRzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:55:04 -0400
Date: Thu, 19 Apr 2007 20:54:55 +0300
From: Avi Kivity <avi@argo.co.il>
Subject: Re: [RFC 6/8] Account for pages in the page cache in terms of base
 pages
In-reply-to: <Pine.LNX.4.64.0704191051190.12576@schroedinger.engr.sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Message-id: <4627ACEF.8060605@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Enigmail-Version: 0.94.3.0
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 19 Apr 2007 20:54:55 +0300 (IDT)
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163535.11948.91100.sendpatchset@schroedinger.engr.sgi.com>
 <29495f1d0704191045u77e8d7e1g87954549b82a0306@mail.gmail.com>
 <Pine.LNX.4.64.0704191051190.12576@schroedinger.engr.sgi.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 19 Apr 2007, Nish Aravamudan wrote:
>
>   
>>> NR_FILE_PAGES,
>>> +                                       1 << mappig->order);
>>>       
>> Typo? should be mapping->order?
>>     
>
> Correct. Sigh. Why do these things creep in at the last minute before 
> posting???
>   

To make sure you know that somebody's read them?


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

