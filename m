Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbXKATD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbXKATD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbXKATDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:03:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbXKATDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:03:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=CrOnJdGz6gSQ7J689kxR+wDfsDHfNO1dhpAxZ18ZoDLGUeMEY2yrgFnpmsB8ppUDO
	4z0cee9AXn2+DVcrmhSvw==
Date: Thu, 1 Nov 2007 12:03:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071101090612.e0c86ddb.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0711011202190.21823@chino.kir.corp.google.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com> <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com> <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com> <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com> <20071031233352.959c32d0.pj@sgi.com> <Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com> <20071101090612.e0c86ddb.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Paul Jackson wrote:

> We were discussing libnuma here, not glibc.  The system call wrappers
> are in glibc.  System call wrappers should not be setting optional
> flags.  They should just make the system call -- do whatever magic it
> takes to get the provided arguments into the right registers or other
> conventionally determined places, and invoke the necessary machine
> instruction to trap into the kernel.
> 

So there is no problem with allowing modal flags to be passed to 
set_mempolicy() because glibc will respect the mode actual and pass it 
right along to the kernel.  That gives the power to the programmer to 
specify whether he or she, based on the updated documentation, wants the 
nodemask to be interpreted in terms of the system or cpuset.

		David
