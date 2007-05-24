Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbXEXQkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbXEXQkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXEXQkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:40:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58830 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750724AbXEXQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:40:38 -0400
Date: Thu, 24 May 2007 09:40:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <20070524073131.GA17501@elte.hu>
Message-ID: <Pine.LNX.4.64.0705240938070.27844@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
 <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
 <20070523153730.e0e9e91d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
 <20070524073131.GA17501@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Ingo Molnar wrote:

> 
> when constructing debug output it's a good idea to make it as 
> 'context-free' as possible. I.e. instead of saying 'Filler' and 
> explaining it somewhere in Documentation/*, just say:
> 
>   Expected memory values at 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a
>   ... but found the following values:    12 34 56 78 90 12 34 56

Meaning just print the corrupted values? Otherwise the text will take up 
a lot of real estate and will make it impossible to view the actual object 
contents.

I think I can skip the filler etc if its not corrupted. Maybe that will 
help?

