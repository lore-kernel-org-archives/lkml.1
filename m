Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbZFVBz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbZFVBz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 21:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZFVBzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 21:55:50 -0400
Received: from tundra.namei.org ([65.99.196.166]:41854 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZFVBzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 21:55:49 -0400
Date: Mon, 22 Jun 2009 11:54:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: Pavel Machek <pavel@ucw.cz>, Joseph Cihula <joseph.cihula@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hpa@zytor.com, andi@firstfloor.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
In-Reply-To: <20090619183414.GG19771@sequoia.sous-sol.org>
Message-ID: <alpine.LRH.2.00.0906221135550.18633@tundra.namei.org>
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org> <20090619150514.GE1389@ucw.cz> <20090619183414.GG19771@sequoia.sous-sol.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Chris Wright wrote:

> * Pavel Machek (pavel@ucw.cz) wrote:
> > What are non-evil uses of this code?
> 
> The most common use case I've heard requested from real live
> customers[1] is...you guessed it...trusted boot.
> 
> This is typically in the context of virtualization and data centers or
> clouds.  The concerns being addressed are:
> 
> * confidence that the hardware is running the VMM that the hardware
>   owner configured it w/, since they are on the hook for providing a
>   safe service for each VM running on that hardware
> 
> * flip side of that is an additional layer protecting against malicious
>   VM that is using some VMM hole to try and subvert the host w/ a VMM
>   of their own

Agreed.  I'd also mention (again), these slides on the topic by Joanna 
Rutkowska:

http://invisiblethingslab.com/resources/misc09/trusted_computing_thoughts.pdf

Also, hardware security measures such as TXT are important in providing 
stronger mechanisms to ensure that kernel security mechanisms are 
functioning correctly.


- James
-- 
James Morris
<jmorris@namei.org>
