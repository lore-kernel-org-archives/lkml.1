Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXDMLbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXDMLbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXDMLbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:31:32 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:32061 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753553AbXDMLbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:31:31 -0400
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Fri, 13 Apr 2007 12:31:13 +0100
Subject: Re: [PATCH 0/4] i386 - pte update optimizations
From: Keir Fraser <keir@xensource.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C2452891.D417%keir@xensource.com>
Thread-Topic: [PATCH 0/4] i386 - pte update optimizations
Thread-Index: Acd9vz2ofH0bHOmyEdu6zAAX8io7RQ==
In-Reply-To: <p738xcw7942.fsf@bingen.suse.de>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/4/07 13:27, "Andi Kleen" <andi@firstfloor.org> wrote:

>> LOCKed instruction suck really badly on the netburst microarchitecture (like
>> factor of 10x, or not far off). I think it's probably because of their side
>> effect of serialising memory accesses, causing horrible pipeline stalls.
> 
> Unfortunately they tend to be HyperThreaded usually (except for early ones
> and Celerons) and need the LOCK anyways.

Fair point, although quite a few people disable HT.

 -- Keir

