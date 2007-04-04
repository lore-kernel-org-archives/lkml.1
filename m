Return-Path: <linux-kernel-owner+w=401wt.eu-S2992962AbXDDPgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992962AbXDDPgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDDPgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:36:54 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3894 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992962AbXDDPgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:36:53 -0400
Message-ID: <4613C612.5040600@rtr.ca>
Date: Wed, 04 Apr 2007 11:36:50 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Chris Snook <csnook@redhat.com>, Paa Paa <paapaa125@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com> <4612852C.2030801@rtr.ca> <4612A854.1070702@cfl.rr.com>
In-Reply-To: <4612A854.1070702@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Mark Lord wrote:
>> But WD drives, in particular the Raptor series, have a firmware "feature"
>> that disables "drive readahead" whenever NCQ is in use.
> 
> Why is this an issue?  Shouldn't the kernel be sending down its own 
> readahead requests to keep the disk busy?

The drive firmware readahead is inherently *way* more effective than
other forms, and without it, sequential read performance really suffers.
Regardless of how software tries to compensate.

This is mostly a problem with the WD Raptor drive, and some other WD drives.
I have not yet encountered/noticed the problem with other brands.

-ml
